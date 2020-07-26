//
//  ViewController.swift
//  DearDiary
//
//  Created by Ronit Dhingra on 6/26/20.
//  Copyright © 2020 Ronit Dhingra. All rights reserved.
//

import UIKit
import CryptoKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import GoogleSignIn
import AuthenticationServices

/// The class created to manage data on the home view controller, or the root view that is present when you open the app for the first time
class HomeViewController: UIViewController {

    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var homeStackView: UIStackView!
    
    @IBOutlet weak var facebookButton: UIButton!
    
    @IBOutlet weak var googleButton: UIButton!
    
    @IBOutlet weak var AppleLoginButton: UIButton!
    
    @IBOutlet weak var passwordlessButton: UIButton!
    
    let selectedImage = UIImage(named: "defaultProfilePicture")
    
    fileprivate var currentNonce: String?
    
    private let FacebookLoginButton: FBLoginButton! = {
        let button = FBLoginButton()
        button.permissions = ["email", "public_profile"]
        return button
    }()
    
    private let GoogleLoginButton: GIDSignInButton! = {
        let button = GIDSignInButton()
        return button
    }()
    
    private let ASALoginButon: ASAuthorizationAppleIDButton! = {
        let button = ASAuthorizationAppleIDButton(type: .continue, style: .white)
        return button
    }()
    
    private var loginObserver: NSObjectProtocol!
    
    @objc func handleAppleLogin() {
        if #available(iOS 13.0, *) {
            // Generating our nonce validation string
            let nonce = randomNonceString()
            currentNonce = nonce
            
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            request.nonce = sha256(nonce)
            
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.presentationContextProvider = self
            authorizationController.performRequests()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        loginObserver = NotificationCenter.default.addObserver(forName: Notification.Name(""), object: nil, queue: .main, using: { [weak self] (notification) in
            
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.navigationController?.dismiss(animated: true, completion: nil)
            
            strongSelf.transitionToFeed()
        })
        
        setupElements()
        GIDSignIn.sharedInstance()?.presentingViewController = self
        FacebookLoginButton.delegate = self
        facebookButton.alpha = 0
        googleButton.alpha = 0
        AppleLoginButton.alpha = 0
        homeStackView.addSubview(FacebookLoginButton)
        homeStackView.addSubview(GoogleLoginButton)
        homeStackView.addSubview(ASALoginButon)
        ASALoginButon.addTarget(self, action: #selector(handleAppleLogin), for: .touchUpInside)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        // Open the mail app when email link has been sent
        if SetupPlist.shouldOpenMailApp {
            SetupPlist.shouldOpenMailApp = false
            if let url = URL(string: "message://") {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                } else {
                    UIAlertService.showAlert(style: .alert, title: "Error", message: "Could not open Mail app")
                }
            }
        }
    }
    
    deinit {
        if loginObserver != nil {
            NotificationCenter.default.removeObserver(loginObserver)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkValidation()
    }
    
    override func viewDidLayoutSubviews() {
        FacebookLoginButton.frame = CGRect(x: 0, y: 0, width: 334, height: 50)
        GoogleLoginButton.frame = CGRect(x: 0, y: 70, width: 334, height: 50)
        ASALoginButon.frame = CGRect(x: 0, y: 140, width: 334, height: 45)
        
        
        // Centering the theird party buttons in perspective of the stack view
        NSLayoutConstraint.activate([
                                        FacebookLoginButton.centerXAnchor.constraint(equalTo: homeStackView.centerXAnchor),
                                        ASALoginButon.centerXAnchor.constraint(equalTo: homeStackView.centerXAnchor),
                                        GoogleLoginButton.centerXAnchor.constraint(equalTo: homeStackView.centerXAnchor)])
        
    }
    
    func setupElements() {
        
        // Style our buttons and entry label
        Utilities.roundenButton(facebookButton)
        Utilities.roundenButton(AppleLoginButton)
        Utilities.styleFilledButton(signUpButton)
        Utilities.styleHollowButton(loginButton)
        Utilities.styleFilledButton(passwordlessButton)
    }
    
    
    
    
    func checkValidation() {
        
        if KeychainWrapper.standard.object(forKey: "uid") != nil {
            self.transitionToFeed()
        }
    }
    
    func transitionToFeed() {
        
        let feedViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.setupViewController) as? FeedTableViewController
        
        view.window?.rootViewController = feedViewController
        view.window?.makeKeyAndVisible()
    }
    
    // Store the apple user data in Firebase server, following the Apple ID condition
    func storeAppleUserDataStandard(firstName: String!, lastName: String!, email: String!, userId: String!, username: String!) {
        
        if let imageData = selectedImage!.jpegData(compressionQuality: 0.2) {
            
            let uploadTask = Storage.storage().reference().child("apple-users").child("user-profile-pics").child(userId).putData(imageData, metadata: nil) { (metadata, error) in
                
                guard metadata != nil else {
                    print("Failed to upload profile image")
                    return
                }
                
                let downloadURL = Storage.storage().reference().downloadURL
                
                // User was created successfully; store credentials
                let db = Database.database()
                
                KeychainWrapper.standard.set(userId, forKey: "uid")
                
                let userData = ["firstname": firstName!, "lastname": lastName!, "username": username!, "userid": userId!] as [String : Any]
                
                db.reference().child("apple-users").child(userId).setValue(userData) { (err, ref) in
                    
                    if err != nil {
                        debugPrint("Error: \(err!.localizedDescription)")
                    }
                    else {
                        debugPrint("Data was saved successfully")
                    }
                }
                
            }
            
            uploadTask.resume()
            
            
            
            
        }
        
        
        
    }


    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension HomeViewController: LoginButtonDelegate, ASAuthorizationControllerPresentationContextProviding, ASAuthorizationControllerDelegate {
    
    
    // Facebook Login Details
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        // No Action Taken
    }
    
    
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        guard let token = result?.token?.tokenString else {
            debugPrint("An error occured")
            return
        }
        
        
        
        
        let facebookRequest = FBSDKLoginKit.GraphRequest(graphPath: "me", parameters: ["fields": "email, name"], tokenString: token, version: nil, httpMethod: .get)
        
        
        facebookRequest.start { (_, result, error) in
            guard let result = result as? [String:Any], error == nil else {
                print("Failed to create graph request")
                return
            }
            
            guard let username = result["name"] as? String, let email = result["email"] as? String else {
                print("Failed to retrieve email and name from FB request.")
                return
            }
            
            let nameComponents = username.components(separatedBy: " ")
            
            let firstName = nameComponents[0]
            let lastName = nameComponents[1]
            
            let credentials = FacebookAuthProvider.credential(withAccessToken: token)
            
            Auth.auth().signIn(with: credentials) { [weak self] (authResult, err) in
                guard let strongSelf = self else {
                    return
                }
                
                guard let result = authResult, err == nil else {
                    print("Authentication failed: \(err!)")
                    
                    return
                }
                
                Database.database().reference().child("CloverNotes").child("facebook-users").setValue(["firstname": firstName, "lastname": lastName, "email": email, "uid": Auth.auth().currentUser?.uid]) { (err, ref) in
                    
                    if err != nil {
                        debugPrint("Error: \(err!.localizedDescription)")
                    }
                    else {
                        debugPrint("Data was saved successfully")
                    }
                }
                
                strongSelf.navigationController?.dismiss(animated: true, completion: nil)
                
                strongSelf.transitionToFeed()
            }
            
            
        }
        
        
    }
    
    // Apple auth pop-up setup
    @available(iOS 13.0, *)
        func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
            return self.view.window!
        }
    
    // Sign in with Apple
    
    // An error occured
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Error signing with Apple: \(error.localizedDescription)")
    }
    
    // User created successfully
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            // Get user data with Apple ID credentitial
            let userId = appleIDCredential.user
            let userFirstName = appleIDCredential.fullName?.givenName
            let userLastName = appleIDCredential.fullName?.familyName
            
            guard userLastName != nil, userFirstName != nil else {
                return
            }
            
            let userEmail = appleIDCredential.email
            let username = userFirstName! + userLastName!
            
            print("User ID: \(userId)")
            print("User First Name: \(userFirstName ?? "")")
            print("User Last Name: \(userLastName ?? "")")
            print("User Email: \(userEmail ?? "")")
            print("Auto generated username: \(username)")
            
            // Register the data in
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            
            // Initialize a Firebase credential.
            let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                      idToken: idTokenString,
                                                      rawNonce: nonce)
            
            // Create the user and store it in Firebase Authentication
            Auth.auth().signIn(with: credential) { [weak self] (result, error) in
                guard let strongSelf = self else {
                    return
                }
                
                guard error != nil else {
                    if let error = error {
                        print("Error creating user: \(error.localizedDescription)")
                    }
                    return
                }
                
                strongSelf.storeAppleUserDataStandard(firstName: userFirstName, lastName: userLastName, email: userEmail, userId: userId, username: username)
                
                
                
            }
            
        } else if let passwordCredential = authorization.credential as? ASPasswordCredential {
            // Get user data using an existing iCloud Keychain credential
            let appleUsername = passwordCredential.user
            let applePassword = passwordCredential.password
           
            let alert = UIAlertController(title: "Error", message: "This method of authentication cannot be used in this application. Please use the apple id authenticaton method, or try again later. Sorry for the inconvience.", preferredStyle: .alert)
            
            let dismiss = UIAlertAction(title: "Ok", style: .cancel) { (action) in
                
                let homeViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.setupViewController) as? HomeViewController
                
                self.view.window?.rootViewController = homeViewController
                self.view.window?.makeKeyAndVisible()
            }
            
            alert.addAction(dismiss)
            
            present(alert, animated: true, completion: nil)
        }
    }
    
    // Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
    
    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        return String(format: "%02x", $0)
      }.joined()

      return hashString
    }
    
    
}




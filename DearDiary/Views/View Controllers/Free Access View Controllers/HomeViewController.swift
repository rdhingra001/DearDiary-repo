//
//  ViewController.swift
//  DearDiary
//
//  Created by Ronit Dhingra on 6/26/20.
//  Copyright © 2020 Ronit Dhingra. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import GoogleSignIn

class HomeViewController: UIViewController {

    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var homeStackView: UIStackView!
    
    @IBOutlet weak var facebookButton: UIButton!
    
    @IBOutlet weak var googleButton: UIButton!

    
    private let FacebookLoginButton: FBLoginButton! = {
        let button = FBLoginButton()
        button.permissions = ["email", "public_profile"]
        return button
    }()
    
    private let GoogleLoginButton: GIDSignInButton! = {
        let button = GIDSignInButton()
        return button
    }()
    
    private var loginObserver: NSObjectProtocol!
    
    
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
        homeStackView.addSubview(FacebookLoginButton)
        homeStackView.addSubview(GoogleLoginButton)
        
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
        GoogleLoginButton.frame = CGRect(x: 0, y: 80, width: 334, height: 50)
    }
    
    func setupElements() {
        
        // Style our buttons and entry label
        Utilities.styleFilledButton(signUpButton)
        Utilities.styleHollowButton(loginButton)
        
        // Give our third-party login options the rounded button
        Utilities.roundenButtonFacebook(FacebookLoginButton)
        Utilities.roundenButtonGoogle(GoogleLoginButton)
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


    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension HomeViewController: LoginButtonDelegate {
    
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
                
                Database.database().reference().child("CloverNotes").child("facebook-users").setValue(["firstname": firstName, "lastname": lastName, "email": email, "uid": Auth.auth().currentUser?.uid])
                
                strongSelf.navigationController?.dismiss(animated: true, completion: nil)
                
                strongSelf.transitionToFeed()
            }
            
            
        }
        
        
    }
}




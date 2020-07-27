//
//  LoginViewController.swift
//  DearDiary
//
//  Created by Ronit Dhingra on 6/26/20.
//  Copyright © 2020 Ronit Dhingra. All rights reserved.
//

import UIKit
import CoreData
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBOutlet weak var loginButton: UIButton!
    
    
    @IBOutlet weak var errorLabel: UILabel!
    
    // Initializing the app delegate Core Data model view in a constants file
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var authHud = AuthHUD.create()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupElements()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkValidation()
    }
    func setupElements() {
        
        // Hide the error label
        errorLabel.alpha = 0
        
        // Style our text fields
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        
        // Style the button
        Utilities.styleFilledButton(loginButton)
    }
    
    
    
    @IBAction func loginTapped(_ sender: Any) {
        
        // Validate the fields
        let error = validateFields()
        
        if error != nil {
            
            // There's something wrong with the fields; show error message
            showError(error!)
        }
        else {
            
            AuthHUD.handle(authHud, with: AuthHudInfo(type: .show, text: "Processing", detailText: "Logging you in..."))
                        
            // Create cleaned versions of the user data
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Signing the user
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] (result, error) in
                
                guard let strongSelf = self else {
                    return
                }
                
                if error != nil {
                    
                    // Couldn't sign in
                    AuthHUD.handle(strongSelf.authHud, with: AuthHudInfo(type: .error, text: "Error", detailText: error.debugDescription))
                    print(error!.localizedDescription)
                }
                else {
                    
                    let uid = Auth.auth().currentUser?.uid
                    
                    let UserData = UserDataDemo(context: strongSelf.context)
                    
                    KeychainWrapper.standard.set(uid!, forKey: "uid")
                    
                    CacheManager.email = email
                    debugPrint("Email: \(CacheManager.email ?? "No email found")")
                    CacheManager.password = password
                    debugPrint("Password: \(CacheManager.password ?? "No password found")")
                    CacheManager.uid = uid
                    debugPrint("UID: \(CacheManager.uid ?? "No uid found")")
                    
                    strongSelf.transitionToFeed()
                }
            }
            
            
        }
        
    }
    
    func showMessage(_ title: String?, message: String?) {
        
        // Creating the error popup that will appear if an error occurs
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        // Defining the action
        let acceptAction = UIAlertAction(title: "Continue", style: .default) { (acceptAction) in
            print(acceptAction)
        }
        
        let declineAction = UIAlertAction(title: "Go back", style: .destructive) { (declineAction) in
            print(declineAction)
        }
        
        alert.addAction(acceptAction)
        alert.addAction(declineAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    // Validate the fields
    func validateFields() -> String? {
        
        // Check that all fields are filled in
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill in all the fields"
        }
        
        // Check if the password is secure
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Validation.isPasswordValid(cleanedPassword) == false {
            // Password isn't secure enough
            return "Please make sure your password is at least 8 characters, contains a special character, and a number. "
        }
        
        return nil
    }
    
    func showError(_ message:String) {
        
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func transitionToSetup() {
        
        let profileViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.setupViewController) as? ProfileViewController
        
        view.window?.rootViewController = profileViewController
        view.window?.makeKeyAndVisible()
    }
    
    func transitionToFeed() {
        
        let FeedTableViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.feedTableViewController) as? FeedTableViewController
        
        view.window?.rootViewController = FeedTableViewController
        view.window?.makeKeyAndVisible()
    }
    
    func checkValidation() {
        
        if KeychainWrapper.standard.object(forKey: "uid") != nil {
            self.transitionToFeed()
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

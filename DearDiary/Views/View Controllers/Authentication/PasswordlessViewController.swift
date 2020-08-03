//
//  PasswordlessViewController.swift
//  SocialSpark
//
//  Created by  Ronit D. on 7/25/20.
//  Copyright © 2020 Ronit Dhingra. All rights reserved.
//

import UIKit
import Firebase
import CoreData

class PasswordlessViewController: UIViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var sendLinkButton: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var activityMonitor: UIActivityIndicatorView!
    
    var authHud = AuthHUD.create()
    var loginObserver: NSObjectProtocol!

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
        
        sendLinkButton.addTarget(self, action: #selector(sendLinkToUser), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
    }
    
    func transitionToFeed() {
        
        let feedTableViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.feedTableViewController) as? FeedTableViewController
        
        view.window?.rootViewController = feedTableViewController
        view.window?.makeKeyAndVisible()
    }
    
    func setupElements() {
        
        Utilities.styleTextField(firstNameTextField)
        Utilities.styleTextField(lastNameTextField)
        Utilities.styleTextField(usernameTextField)
        Utilities.styleTextField(emailTextField)
        Utilities.styleFilledButton(sendLinkButton)
        statusLabel.tintColor = UIColor.black
        
        activityMonitor.alpha = 0
        statusLabel.alpha = 0
    }
    
    func validateFields() -> String? {
        
        // Making sure that the user typed in their credentials in the given spaces
        if firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            usernameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill in all the fields"
        }
        
        return nil
    }
    
    func showError(_ message: String?) {
        statusLabel.alpha = 1
        statusLabel.tintColor = UIColor.red
        statusLabel.text = message
    }
    
    @objc func sendLinkToUser(_ sender: Any) {
        let error = validateFields()
        
        guard error == nil else {
            self.showError(error)
            return
        }
        
        AuthHUD.handle(authHud, with: AuthHudInfo(type: .show, text: "Processing", detailText: "Sending email..."))
        
        let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let username = usernameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let actionCodeSettings = ActionCodeSettings()
        
        let scheme = PlistParser.getStringValue(SetupPlist.kFirebaseOpenAppScheme)
        let urlPrefix = PlistParser.getStringValue(SetupPlist.kFirebaseOpenAppURLPrefix)
        let queryItemsEmailName = PlistParser.getStringValue(SetupPlist.kFirebaseOpenAppQueryItemEmailName)
        
        var components = URLComponents()
        components.scheme = scheme
        components.host = urlPrefix
        
        let emailURLQueryItem = URLQueryItem(name: queryItemsEmailName, value: email)
        components.queryItems = [emailURLQueryItem]
        
        guard let linkParameters = components.url else { return }
        print("The link parameter is \(linkParameters)")
        
        actionCodeSettings.url = linkParameters
        actionCodeSettings.handleCodeInApp = true
        actionCodeSettings.setIOSBundleID(Bundle.main.bundleIdentifier!)
        
        Auth.auth().sendSignInLink(toEmail: email, actionCodeSettings: actionCodeSettings) { [weak self] (err) in
            
            guard let strongSelf = self else {
                return
            }
            
            guard err == nil else {
                print("Error: \(err!.localizedDescription)")
                AuthHUD.handle(strongSelf.authHud, with: AuthHudInfo(type: .error, text: "Error", detailText: "There has been an error: \(err!.localizedDescription)"))
                return
            }
            
            // Store the user's creds so they don't need to login everytime
            CacheManager.firstName = firstName
            print("First name: \(firstName)")
            CacheManager.lastName = lastName
            print("Last name: \(lastName)")
            CacheManager.username = username
            print("Username: \(username)")
            CacheManager.email = email
            print("Email: \(email)")
            
            AuthHUD.handle(strongSelf.authHud, with: AuthHudInfo(type: .success, text: "Success", detailText: "Email sent!"))
            
            // Present the confirmation email to the user by accessing the UIAlertController
            let openMailAppAction = UIAlertAction(title: "Check Mail", style: .default, handler: { (action) in
                SetupPlist.shouldOpenMailApp = true
                strongSelf.dismiss(animated: true, completion: nil)
            })
            let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: { (action) in
                strongSelf.dismiss(animated: true, completion: nil)
            })
            
            SetupPlist.shouldOpenMailApp = true
            UIAlertService.showAlert(style: .alert, title: "Check your email", message: "Sent the email \(email) a confirmation link", actions: [openMailAppAction,okAction], completion: nil)
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

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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        sendLinkButton.addTarget(self, action: #selector(sendLinkToUser), for: .touchUpInside)
        setupElements()
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
        
        // Making sure that the user typed in their email in the given space
        guard emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) != "" else {
            return "Please type in your email in the given field"
        }
        
        return nil
    }
    
    func showError(_ message: String?) {
        statusLabel.alpha = 0
        statusLabel.tintColor = UIColor.red
        statusLabel.text = message
    }
    
    @objc func sendLinkToUser(_ sender: Any) {
        let error = validateFields()
        
        guard error == nil else {
            self.showError(error)
            return
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

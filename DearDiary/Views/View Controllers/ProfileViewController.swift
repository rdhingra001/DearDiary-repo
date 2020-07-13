//
//  SetupViewController.swift
//  DearDiary
//
//  Created by Ronit Dhingra on 6/26/20.
//  Copyright © 2020 Ronit Dhingra. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var welcomeLabel: UILabel!
    
    @IBOutlet weak var headerLabel: UILabel!
    
    @IBOutlet weak var hiddenLabel: UILabel!
    
    @IBOutlet weak var firstImageView: UIImageView!
    
    @IBOutlet weak var secondImageView: UIImageView!
    
    @IBOutlet weak var lastImageView: UIImageView!

    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupElements()
        
    }
    
    
    @IBAction func signOutTapped(_ sender: Any) {
        
        let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
        
        do {
            try Auth.auth().signOut()
            
            view.window?.rootViewController = homeViewController
            view.window?.makeKeyAndVisible()
        }
        catch let signOutError as NSError {
            print("Error: \(signOutError)")
            showMessage("Error", message: "Unfortunately, there is an error and you could not be logged out. Sorry for the inconvenience :(.", dismiss: "Dismiss")
        }
        

    }
    
    func setupElements() {
        
        // Set up the elements once user finishes logging in
        if firstImageView != nil || secondImageView != nil || lastImageView != nil {
            hiddenLabel.alpha = 0
        }
        
        Utilities.styleSetupLabel(headerLabel)
        Utilities.styleSetupLabel(hiddenLabel)
        
    }
    
    func showMessage(_ title: String?, message: String?, dismiss: String?) {
        
        // Creating the error popup that will appear if an error occurs
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Defining the action
        let action = UIAlertAction(title: dismiss, style: .default) { (action) in
            print(action)
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }


}

//
//  ViewController.swift
//  DearDiary
//
//  Created by Ronit Dhingra on 6/26/20.
//  Copyright © 2020 Ronit Dhingra. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var loginButton: UIButton!
    
    
    @IBOutlet weak var signUpPasswordLessButton: UIButton!
    
    
    @IBOutlet weak var loginPasswordLessButton: UIButton!
    
    @IBOutlet weak var dearDiaryTitleLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupElements()
        checkValidation()
    }
    
    func setupElements() {
        
        // Style our buttons and entry label
        Utilities.styleLabel(dearDiaryTitleLabel)
        Utilities.styleFilledButton(signUpButton)
        Utilities.styleFilledButton(signUpPasswordLessButton)
        Utilities.styleHollowButton(loginButton)
        Utilities.styleHollowButton(loginPasswordLessButton)
    }
    
    
    func checkValidation() {
        
        if KeychainWrapper.standard.object(forKey: "uid") != nil {
            self.transitionToSetup()
        }
    }
    
    func transitionToSetup() {
        
        let setupViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.setupViewController) as? SetupViewController
        
        view.window?.rootViewController = setupViewController
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


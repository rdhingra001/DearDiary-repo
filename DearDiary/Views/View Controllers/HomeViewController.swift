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
    
    @IBOutlet weak var CloverNotesTitleLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupElements()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkValidation()
    }
    
    func setupElements() {
        
        // Style our buttons and entry label
        Utilities.styleLabel(CloverNotesTitleLabel)
        Utilities.styleFilledButton(signUpButton)
        Utilities.styleHollowButton(loginButton)
    }
    
    
    func checkValidation() {
        
        if KeychainWrapper.standard.object(forKey: "uid") != nil {
            self.transitionToSetup()
        }
    }
    
    func transitionToSetup() {
        
        let setupViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.setupViewController) as? ProfileViewController
        
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


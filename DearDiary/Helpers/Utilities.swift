//
//  Utilities.swift
//  DearDiary
//
//  Created by Ronit Dhingra on 6/26/20.
//  Copyright © 2020 Ronit Dhingra. All rights reserved.
//

import Foundation
import UIKit
import FBSDKLoginKit
import GoogleSignIn

class Utilities {
    
    static var customColor: UIColor = UIColor.init(red: 30/255, green: 125/255, blue: 165/255, alpha: 1)
    
    static func styleTextField(_ textfield:UITextField) {
        
        // Create the bottom line
        let bottomLine = CALayer()
        
        bottomLine.frame = CGRect(x: 0, y: textfield.frame.height - 2, width: textfield.frame.width, height: 2)
        
        bottomLine.backgroundColor = customColor.cgColor
        
        // Remove border on text field
        textfield.borderStyle = .none
        
        // Add the line to the text field
        textfield.layer.addSublayer(bottomLine)
        
    }
    
    static func styleFilledButton(_ button:UIButton) {
        
        // Filled rounded corner style
        button.backgroundColor = customColor
        button.layer.cornerRadius = 15.0
        button.tintColor = UIColor.white
    }
    
    static func styleSelecterButton(_ button: UIButton) {
        
        // Filled rounded corner style
        button.backgroundColor = customColor
        button.layer.cornerRadius = 5.0
        button.tintColor = UIColor.white
        
    }
    
    static func styleHollowButton(_ button:UIButton) {
        
        // Hollow rounded corner style
        button.layer.borderWidth = 2
        button.layer.borderColor = customColor.cgColor
        button.layer.cornerRadius = 15.0
        button.tintColor = UIColor.white
        button.titleLabel?.alpha = 2
    }
    
    static func styleLabel(_ label:UILabel) {
        
        label.textColor = UIColor.init(red: 58/255, green: 134/255, blue: 133/255, alpha: 0.93375)
        label.layer.cornerRadius = 75.0
    
    }
    
    static func styleSetupLabel(_ label:UILabel) {
        
        label.textColor = UIColor.init(red: 48/255, green: 129/255, blue: 143/255, alpha: 0.93275)
        label.layer.cornerRadius = 75.0
        
    }
    
    static func roundenButtonFacebook(_ button: FBLoginButton) {
        
        button.layer.cornerRadius = 25.0
    }
    
    static func roundenButtonGoogle(_ button: GIDSignInButton) {
        
        button.layer.cornerRadius = 25.0
    }
    

}

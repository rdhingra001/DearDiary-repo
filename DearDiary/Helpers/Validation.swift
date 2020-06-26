//
//  Validation.swift
//  DearDiary
//
//  Created by Ronit Dhingra on 6/26/20.
//  Copyright © 2020 Ronit Dhingra. All rights reserved.
//

import Foundation
import UIKit



class Validation {
    
    // Check if the password can be used for logging in
    static func isPasswordValid(_ password : String) -> Bool {
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
}




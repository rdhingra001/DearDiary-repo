//
//  Constants.swift
//  DearDiary
//
//  Created by Ronit Dhingra on 6/26/20.
//  Copyright © 2020 Ronit Dhingra. All rights reserved.
//

import Foundation
import UIKit
import Firebase

struct Constants {
    
    struct Storyboard {
        
        // Creating storyboard properties for the Swift backend
        static let setupViewController = "SetupVC"
        static let signUpViewController = "SignUpVC"
        static let loginViewController = "LoginVC"
        static let homeViewController = "HomeVC"
        
    }
    
    struct FirebaseUtilities {
        
        // Initializing the firebase properties
        let storage = Storage.storage()
        let firestore = Firestore.firestore()
        let auth = Auth.auth()
        
    }
    
    
}

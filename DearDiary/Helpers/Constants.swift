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
        static let feedTableViewController = "FeedVC"
        static let navigationController = "NavVC"
        static let tabBarController = "TabBarVC"
        
    }
    
    struct FirebaseUtilities {
        
        // Initializing the firebase properties
        public let storage = Storage.storage()
        public let database = Database.database()
        public let auth = Auth.auth()
        
    }
    
    struct CoreDataTools {
        
        // Initializing the app delegate Core Data model view in a constants file
        public let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    
}

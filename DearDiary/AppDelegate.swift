//
//  AppDelegate.swift
//  DearDiary
//
//  Created by Ronit Dhingra on 6/26/20.
//  Copyright © 2020 Ronit Dhingra. All rights reserved.
//

import UIKit
import Firebase
import CoreData
import FBSDKCoreKit
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        ApplicationDelegate.shared.application(
                    application,
                    didFinishLaunchingWithOptions: launchOptions
                )
        
        FirebaseApp.configure()
        
        GIDSignIn.sharedInstance()?.clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance()?.delegate = self
        
        window = UIWindow()
        window?.makeKeyAndVisible()
        let navController = UINavigationController(rootViewController: FeedTableViewController())
        navController.navigationBar.barStyle = .black
        window?.rootViewController = navController
        
        return true
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        guard error == nil else {
            print("Failed to sign in with Google: \(error!)")
            return
        }
        
        let email = user.profile.email
        let firstName = user.profile.givenName
        let lastName = user.profile.familyName
        
        guard let authentication = user.authentication else { return }
        let credentials = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credentials) { (authResult, error) in
            guard authResult != nil, error == nil else {
                if let error = error {
                    print("Error is present: \(error)")
                }
                return
            }
            
            Database.database().reference().child("google-users").child((authResult?.user.uid)!).setValue(["firstname": firstName, "lastname": lastName, "email": email, "uid": Auth.auth().currentUser?.uid]) { (err, ref) in
                
                if err != nil {
                    debugPrint("Error: \(err!.localizedDescription)")
                    return
                }
                else {
                    debugPrint("Data was saved successfully")
                }
            }
            
            print("Google user was successfully created")
            NotificationCenter.default.post(name: Notification.Name(""), object: nil)
        }
        
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print("Google user was disconnected")
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func application(
            _ app: UIApplication,
            open url: URL,
            options: [UIApplication.OpenURLOptionsKey : Any] = [:]
        ) -> Bool {

            ApplicationDelegate.shared.application(
                app,
                open: url,
                sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                annotation: options[UIApplication.OpenURLOptionsKey.annotation]
            )
            
            return GIDSignIn.sharedInstance().handle(url)

        }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        return userActivity.webpageURL.flatMap(handlePasswordlessSignIn)!
    }
    
    func handlePasswordlessSignIn(_ withURL: URL) -> Bool {
        
        let link = withURL.absoluteString
        
        if Auth.auth().isSignIn(withEmailLink: link) {
            
            guard let email = CacheManager.email else { return false }
            
            // Sign in the user
            Auth.auth().signIn(withEmail: email, link: link) { (result, err) in
                
                guard err == nil else {
                    print(err!.localizedDescription)
                    return
                }
                
                guard result != nil else { return }
                
                let uid = result!.user.uid
                CacheManager.uid = uid
                
                let data = ["firstname": CacheManager.firstName, "lastname": CacheManager.lastName, "username": CacheManager.username, "userId": uid ]
                Database.database().reference().child("basic-auth-users").child(uid).setValue(data) { (err, ref) in
                    
                    if err != nil {
                        debugPrint("Error: \(err!.localizedDescription)")
                        UIAlertService.showAlert(style: .alert, title: "Error", message: "Error: \(err.debugDescription)")
                        return
                    }
                    
                    let action = UIAlertAction(title: "Go to Feed", style: .default) { (action) in
                        NotificationCenter.default.post(name: Notification.Name(""), object: nil)
                    }
                    
                    UIAlertService.showAlert(style: .actionSheet, title: "Success", message: "Successfully logged in!", actions: [action], completion: nil)
                }
            }
        }
        return false
    }
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentCloudKitContainer(name: "DearDiary")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }


}



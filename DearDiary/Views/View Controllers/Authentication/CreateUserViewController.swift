//
//  CreateUserViewController.swift
//  DearDiary
//
//  Created by  Ronit D. on 7/20/20.
//  Copyright © 2020 Ronit Dhingra. All rights reserved.
//

import UIKit
import Firebase
import CoreData

class CreateUserViewController: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBOutlet weak var signUpButton: UIButton!
    
    
    @IBOutlet weak var errorLabel: UILabel!
    
    
    @IBOutlet weak var profilePicture: UIImageView!
    
    
    @IBOutlet weak var selecterButton: UIButton!
    
    var selectedImage: UIImage?
    
    var imagePicker: UIImagePickerController!
    
    var items: [UserDataDemo]?
    
    var authHud = AuthHUD.create()
    
    // Initializing the app delegate Core Data model view in a constants file
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupElements()
        
        // Initilizing the UIImagePickerController() func into a variable
        imagePicker = UIImagePickerController()
        
        // Obtaining access to the 'didFinishPickingMediaWithInfo' func
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        let defaultProfilePic = UIImage(named: "defaultProfilePicture")
        
        // Setting the selected image as the default pic at startup
        selectedImage = defaultProfilePic
        
        // Giving the image view rounded corners
        profilePicture.clipsToBounds = true
        profilePicture.layer.cornerRadius = profilePicture.frame.width / 2
        
        view.backgroundColor = .link
    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkValidation()
    }
    
    func setupElements() {
        
        // Hide the error label
        errorLabel.alpha = 0
        
        // Style our text fields
        Utilities.styleTextField(firstNameTextField)
        Utilities.styleTextField(lastNameTextField)
        Utilities.styleTextField(usernameTextField)
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        
        // Style the button
        Utilities.styleFilledButton(signUpButton)
        Utilities.styleSelecterButton(selecterButton)
    }
    
    // Validate the fields
    func validateFields() -> String? {
        
        // Check that all fields are filled in
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            usernameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill in all the fields"
        }
        
        // Check if the password is secure
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Validation.isPasswordValid(cleanedPassword) == false {
            // Password isn't secure enough
            return "Please make sure your password is at least 8 characters, contains a special character, and a number. "
        }
        
        return nil
    }
    
    // Store the user data in Firebase server
    func storeUserData(firstName: String!, lastName: String!, email: String!, userId: String!, username: String!) {
        
        if let imageData = selectedImage?.jpegData(compressionQuality: 0.2) {
            
            let uploadTask = Storage.storage().reference().child("users").child("user-profile-pics").child(email).putData(imageData, metadata: nil) { (metadata, error) in
                
                guard metadata != nil else {
                    print("Failed to upload profile image")
                    return
                }
                
                let downloadURL = Storage.storage().reference().downloadURL
                
                // User was created successfully; store credentials
                let db = Database.database()
                
                KeychainWrapper.standard.set(userId, forKey: "uid")
                
                let userData = ["firstname": firstName!, "lastname": lastName!, "username": username!, "userid": userId!] as [String : Any]
                
                db.reference().child("basic-auth-users").child(userId).setValue(userData) { (err, ref) in
                    
                    if err != nil {
                        self.showError("Data could not be saved")
                        debugPrint("Error: \(err!.localizedDescription)")
                    }
                    else {
                        debugPrint("Data was saved successfully")
                    }
                }
                
            }
            
            uploadTask.resume()
            
            
            
            
        }
        
        

    }
    
    
    // Actions called when selecterButton gets pressed
    @IBAction func getPhoto(_ sender: Any) {
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    // Actions called when Sign Up button is tapped
    @IBAction func signUpTapped(_ sender: Any) {
        
        // Validate the fields
        let error = validateFields()
        
        if error != nil {
            
            // There's something wrong with the fields; show error message
            showError(error!)
        }
        else {
            AuthHUD.handle(authHud, with: AuthHudInfo(type: .show, text: "Processing", detailText: "Creating user..."))
            
            // Create inital records of first and last name
            let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            let username = usernameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Create the user
            Auth.auth().createUser(withEmail: email, password: password) { [weak self] (result, err) in
                
                guard let strongSelf = self else {
                    return
                }
                
                // Check for errors
                if err != nil {
                    
                    // There was an error creating the user
                    AuthHUD.handle(strongSelf.authHud, with: AuthHudInfo(type: .error, text: "Error", detailText: err.debugDescription))
                    print("Error: \(err!.localizedDescription)")
                }
                else {
                    
                    strongSelf.storeUserData(firstName: firstName, lastName: lastName, email: email, userId: result?.user.uid, username: username)
                    
                    // Create an instance of the user saved data onboard to Core Data
                    let UserData = UserDataDemo(context: strongSelf.context)
                    UserData.firstname = firstName
                    UserData.lastname = lastName
                    UserData.username = username
                    UserData.uid = Auth.auth().currentUser!.uid
                    
                    // Cache the user's creds so that they don't need to log in everytime
                    CacheManager.firstName = firstName
                    print("First name: \(CacheManager.firstName ?? "No first name found")")
                    CacheManager.lastName = lastName
                    print("Last name: \(CacheManager.lastName ?? "No last name found")")
                    CacheManager.username = username
                    print("Username: \(CacheManager.username ?? "No username found")")
                    CacheManager.email = email
                    print("Email: \(CacheManager.email ?? "No email found")")
                    CacheManager.password = password
                    print("Password: \(CacheManager.password ?? "No password found")")
                    
                    // Store the creds thru the user-defaults for extra protection
                    
                    // Transition to the setup screen
                    strongSelf.transitionToFeed()
                }
            }
            
            
        }

    }
    
    func showError(_ message:String) {
        
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func transitionToFeed() {
        
        let feedTableViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.tabBarController) as? RDTabBarController
        
        view.window?.rootViewController = feedTableViewController
        view.window?.makeKeyAndVisible()
    }
    
    func checkValidation() {
        
        if KeychainWrapper.standard.object(forKey: "uid") != nil {
            self.transitionToFeed()
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

extension CreateUserViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // What will be called when the user is done picking their image in the UIImagePickerController()
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            
            // Switching the selectedImage as the image clicked on in the UIImagePickerController
            selectedImage = image
            
            // Switching the image view to the selected image to confirm if they clicked on the right image
            profilePicture.image = selectedImage
            
        }
        else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            // Switching the selectedImage as the image clicked on in the UIImagePickerController
            selectedImage = image
            
            // Switching the image view to the selected image to confirm if they clicked on the right image
            profilePicture.image = selectedImage
            
            
        }
        
        // Dismissing the imagePicker
        self.imagePicker.dismiss(animated: true, completion: nil)
    }
    
}




//
//  FeedTableViewController.swift
//  DearDiary
//
//  Created by  Ronit D. on 7/12/20.
//  Copyright © 2020 Ronit Dhingra. All rights reserved.
//

import UIKit
import Firebase

class FeedTableViewController: UITableViewController {
    
    var currentUserImageURL: String!
    
    var Posts = [Post]()
    
    let JGHUD = AuthHUD.create()
    
    let signOutButton = UIImage(named: "signOutImage-1")
    
    @IBOutlet weak var homeTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.backgroundView?.backgroundColor = .link
        
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: signOutButton, style: .plain, target: self, action: #selector(signOut))
    }
    
    func transitionToHome() {
        
        let HomeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
        
        view.window?.rootViewController = HomeViewController
        view.window?.makeKeyAndVisible()
    }

    
    func getUsersData() {
        
        Database.database().reference().child("users").child(KeychainWrapper.standard.string(forKey: "uid")!).observeSingleEvent(of: .value) { (snapshot) in
            
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for data in snapshot {
                    if let postDict = data.value as? Dictionary<String, AnyObject> {
                        self.currentUserImageURL = (postDict["userImg"] as! String)
                    }
                }
            }
        }
    }
    
    func getPosts() {
        Database.database().reference().child("posts").observeSingleEvent(of: .value) { (snapshot) in
            
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else { return }
            self.Posts.removeAll()
            for data in snapshot {
                guard let postDict = data.value as? Dictionary<String, AnyObject> else { return }
                let post = Post(postKey: data.key, postData: postDict)
                self.Posts.append(post)
            }
            self.tableView.reloadData()
        }
    }
    
    @objc func signOut(_ sender: AnyObject) {
        do {
            try Auth.auth().signOut()
        }
        catch let signOutError as NSError {
            AuthHUD.handle(JGHUD, with: AuthHudInfo(type: .error, text: "Error", detailText: "There was an error logging you out. Sorry for the inconvience"))
            print("Error signing out: \(signOutError)")
        }
        dismiss(animated: true, completion: nil)
    }
    
    @objc func toCreatePost(_ sender: Any) {
        
        performSegue(withIdentifier: "toCreatePost", sender: nil)
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

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1 + Posts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.row == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ShareSomethingCell") as? ShareSomethingCell {
                if currentUserImageURL != nil {
                    cell.configCell(currentUserImageURL)
                    cell.shareButton.addTarget(self, action: #selector(toCreatePost), for: .touchUpInside)
                }
                return cell
            }
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell else { return UITableViewCell() }
        cell.configCell(Posts[indexPath.row-1])
        return cell
       
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

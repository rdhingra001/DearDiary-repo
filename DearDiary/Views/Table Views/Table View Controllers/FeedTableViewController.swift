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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(signOut))
    }
    
    func getUsersData() {
        
        
    }
    
    @objc func signOut(_ sender: Any) {
        KeychainWrapper.standard.removeObject(forKey: "uid")
        
        do {
            try Auth.auth().signOut()
        }
        catch let signOutError as NSError {
            showMessage("Error", message: "Unfortunately, there is an error and you could not be logged out. Sorry for the inconvenience :(.", dismiss: "Dismiss")
            print("Error signing out: \(signOutError)")
        }
        dismiss(animated: true, completion: nil)
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
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if let cell = tableView.dequeueReusableCell(withIdentifier: "ShareSomethingCell") as? ShareSomethingCell {
            cell.configCell("")
            return cell
        }
        
        return UITableViewCell()
        
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

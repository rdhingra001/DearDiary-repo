//
//  SparksViewController.swift
//  DearDiary
//
//  Created by  Ronit D. on 8/2/20.
//  Copyright © 2020 Ronit Dhingra. All rights reserved.
//

import UIKit

class SparksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var sparksTableView: UITableView!
    @IBOutlet weak var noSparksLabel: UILabel!
    @IBOutlet weak var noSparksDescriptiveLabel: UILabel!
    
    var models: [(title: String, note: String)] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        view.backgroundColor = .white
        sparksTableView.dataSource = self
        sparksTableView.delegate = self
    }
    
    @IBAction func didTapAddSpark(_ sender: Any) {
        
        guard let vc = storyboard?.instantiateViewController(identifier: "NewSpark") as? NewSparkViewController else { return }
        navigationController?.pushViewController(vc, animated: true)
        vc.title = "New Spark"
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.completion = { noteTitle, note in
            self.navigationController?.popToRootViewController(animated: true)
            self.models.append((title: noteTitle, note: note))
            self.noSparksLabel.isHidden = true
            self.noSparksDescriptiveLabel.isHidden = true
            self.sparksTableView.isHidden = false
            self.sparksTableView.reloadData()
        }
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return models.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SparkCell", for: indexPath) as! SparkCell
        cell.titleLabel.text = models[indexPath.row].title
        cell.noteLabel.text = models[indexPath.row].note
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Show note controller
        
        let model = models[indexPath.row]
        
        guard let vc = storyboard?.instantiateViewController(identifier: "CurrentSpark") as? CurrentSparkViewController else { return }
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.title = "Current Spark"
        vc.noteTitle = model.title
        vc.note = model.note
        navigationController?.pushViewController(vc, animated: true)
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

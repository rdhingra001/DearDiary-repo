//
//  NewChatViewController.swift
//  DearDiary
//
//  Created by  Ronit D. on 7/27/20.
//  Copyright © 2020 Ronit Dhingra. All rights reserved.
//

import UIKit
import JGProgressHUD

class NewChatViewController: UIViewController {
    
    private let spinner: JGProgressHUD = {
        let spin = JGProgressHUD()
        return spin
    }()
    
    private let searchBar: UISearchBar! = {
        let search = UISearchBar()
        search.placeholder = "Search for your friends..."
        return search
    }()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.isHidden = true
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    private let noResultsLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.text = "No Results!"
        label.textAlignment = .center
        label.textColor = .red
        label.font = .systemFont(ofSize: 21, weight: .medium)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .link
        searchBar.delegate = self
        navigationController?.navigationBar.topItem?.titleView = searchBar
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(dismissView))
        searchBar.becomeFirstResponder()
    }
    
    @objc func dismissView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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

extension NewChatViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
}

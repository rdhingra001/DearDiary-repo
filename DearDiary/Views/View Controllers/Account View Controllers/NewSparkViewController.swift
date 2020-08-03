//
//  NewSparkViewController.swift
//  DearDiary
//
//  Created by  Ronit D. on 8/2/20.
//  Copyright © 2020 Ronit Dhingra. All rights reserved.
//

import UIKit

class NewSparkViewController: UIViewController {
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var noteField: UITextView!
    
    public var completion: ((String, String) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        titleField.becomeFirstResponder()
        Utilities.styleTextField(titleField)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveSpark))
    }
    
    @objc func saveSpark(_ sender: Any) {
        if let text = titleField.text, !text.isEmpty, let note = noteField.text, !note.isEmpty {
            completion?(text, note)
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

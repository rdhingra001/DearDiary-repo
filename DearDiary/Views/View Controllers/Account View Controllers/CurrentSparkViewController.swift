//
//  CurrentSparkViewController.swift
//  DearDiary
//
//  Created by  Ronit D. on 8/2/20.
//  Copyright © 2020 Ronit Dhingra. All rights reserved.
//

import UIKit

class CurrentSparkViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var noteLabel: UITextView!
    
    public var noteTitle: String = ""
    public var note: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        titleLabel.text = noteTitle
        noteLabel.text = note
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

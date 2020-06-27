//
//  SetupViewController.swift
//  DearDiary
//
//  Created by Ronit Dhingra on 6/26/20.
//  Copyright © 2020 Ronit Dhingra. All rights reserved.
//

import UIKit
import Firebase

class SetupViewController: UIViewController {
    
    @IBOutlet weak var welcomeLabel: UILabel!
    
    @IBOutlet weak var headerLabel: UILabel!
    
    @IBOutlet weak var hiddenLabel: UILabel!
    
    @IBOutlet weak var firstImageView: UIImageView!
    
    @IBOutlet weak var secondImageView: UIImageView!
    
    @IBOutlet weak var lastImageView: UIImageView!
    
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupElements()
        
    }
    
    func setupElements() {
        
        // Set up the elements once user finishes logging in
        if firstImageView != nil || secondImageView != nil || lastImageView != nil {
            hiddenLabel.alpha = 0
        }
        
        Utilities.styleSetupLabel(headerLabel)
        Utilities.styleSetupLabel(hiddenLabel)
        
    }


}

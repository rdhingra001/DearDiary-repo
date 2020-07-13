//
//  ShareSomethingCell.swift
//  DearDiary
//
//  Created by  Ronit D. on 7/12/20.
//  Copyright © 2020 Ronit Dhingra. All rights reserved.
//

import UIKit
import Firebase

class ShareSomethingCell: UITableViewCell {
    
    @IBOutlet weak var userImageView: UIImageView!
    
    
    @IBOutlet weak var shareSomethingTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configCell(_ userImgUrl: String) {
        
        let httpsReference = Storage.storage().reference(forURL: userImgUrl)
        
        httpsReference.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
            if error != nil {
                // Something went wrong
            }
            else {
                // Return data for user image
                let image = UIImage(data: data!)
                self.userImageView.image = image
            }
        }
    }

}

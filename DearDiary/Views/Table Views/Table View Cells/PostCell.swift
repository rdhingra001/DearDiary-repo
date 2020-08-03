//
//  PostCell.swift
//  DearDiary
//
//  Created by  Ronit D. on 7/20/20.
//  Copyright © 2020 Ronit Dhingra. All rights reserved.
//

import UIKit
import Firebase

/// The table view cell that
class PostCell: UITableViewCell {
    
    
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var user: UILabel!
    
    @IBOutlet weak var postedText: UILabel!
    
    var post: Post!
    let currentUser = KeychainWrapper.standard.string(forKey: "uid")
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configCell(_ post: Post) {
        self.post = post
        self.user.text = post.username
        self.postedText.text = post.postedText
        
        let ref = Storage.storage().reference(forURL: post.userImage)
        ref.getData(maxSize: 100000000) { (data, error) in
            if error != nil {
                debugPrint("Could not load image: \(error!.localizedDescription)")
            }
            else {
                if let imageData = data {
                    if let image = UIImage(data: imageData) {
                        self.userImageView.image = image
                    }
                }
            }
        }
    }

}

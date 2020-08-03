//
//  SparkCell.swift
//  DearDiary
//
//  Created by  Ronit D. on 8/2/20.
//  Copyright © 2020 Ronit Dhingra. All rights reserved.
//

import UIKit

class SparkCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

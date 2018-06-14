//
//  TourTableViewCell.swift
//  MAIV-MobileApp
//
//  Created by Jens Van Steen on 08/06/2018.
//  Copyright © 2018 Team 7 - MAIV. All rights reserved.
//

import UIKit

class TourTableViewCell: UITableViewCell {

    @IBOutlet var tourTitle: UILabel!
    @IBOutlet var tourText: UILabel!
    @IBOutlet var tourImage: UIImageView!
    @IBOutlet var tourCompleted: UILabel!
    @IBOutlet var newView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

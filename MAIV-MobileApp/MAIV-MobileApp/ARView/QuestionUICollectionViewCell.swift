//
//  QuestionUICollectionViewCell.swift
//  MAIV-MobileApp
//
//  Created by Jens Van Steen on 12/06/2018.
//  Copyright © 2018 Team 7 - MAIV. All rights reserved.
//

import UIKit

class QuestionUICollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet var questionCell: UIButton!
    
    var callBack : ((UICollectionViewCell?)->Void)?
    
    @IBAction func getAnswer(_ sender: Any) {
        self.callBack?(self)
    }
    
}

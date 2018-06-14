//
//  StickerDetailViewController.swift
//  MAIV-MobileApp
//
//  Created by Jens Van Steen on 08/06/2018.
//  Copyright © 2018 Team 7 - MAIV. All rights reserved.
//

import UIKit

class StickerDetailViewController: UIViewController {
    
    var selectedSticker: Painting?
    var titleSticker: String?
    var textSticker: String?
    var imageSticker: String?
    var collectStatus: Bool?
    
    @IBOutlet var titleLocked: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var textLabel: UILabel!
    
    
  override func viewDidLoad() {
        super.viewDidLoad()
        
        print(selectedSticker!)
    
        setUPTopBar()
        
    

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
         setUPSticker()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUPTopBar() {
        self.navigationItem.title = selectedSticker!.name
        navigationItem.backBarButtonItem = UIBarButtonItem(title:"back", style: .plain, target: nil, action: nil)
    }
    
    func setUPSticker() {
        
        if collectStatus! {
            titleLocked.text = "Unlocked"
            let imagename = "\(selectedSticker!.id)unlockeddetail"
            imageView.image = UIImage(named: imagename)
//            titleLabel.text = selectedSticker?.name
            textLabel.text = "Je hebt deze sticker gekregen omdat je de Muziek Tour voltooid hebt!"
        } else {
            titleLocked.text = "Locked"
            textLabel.text = "Voltooi de Muziek Tour om deze sticker te voltooien!"
            let imagename = "\(selectedSticker!.id)lockeddetail"
            imageView.image = UIImage(named: imagename)
        }
        
        
        
//         textLabel.text =
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

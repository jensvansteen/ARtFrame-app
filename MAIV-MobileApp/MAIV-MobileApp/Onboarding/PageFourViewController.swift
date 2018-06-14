//
//  PageFourViewController.swift
//  MAIV-MobileApp
//
//  Created by Jens Van Steen on 08/06/2018.
//  Copyright © 2018 Team 7 - MAIV. All rights reserved.
//

import UIKit

class PageFourViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "boardingDone" {
            print("Boarding is done")
            
            UserDefaults.standard.set(true, forKey: "boardingDone")
            UserDefaults.standard.synchronize()
        }
    }
 

}

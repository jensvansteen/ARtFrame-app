//
//  ARScanInstructionViewController.swift
//  MAIV-MobileApp
//
//  Created by Jens Van Steen on 09/06/2018.
//  Copyright © 2018 Team 7 - MAIV. All rights reserved.
//

import UIKit

class ARScanInstructionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTopBar()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpTopBar() {
        self.navigationItem.title = "Scannen"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
    }
    
    @IBAction func goToScanning(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
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

//
//  PickTourViewController.swift
//  MAIV-MobileApp
//
//  Created by Jens Van Steen on 08/06/2018.
//  Copyright © 2018 Team 7 - MAIV. All rights reserved.
//

import UIKit

var tours : Array<Tour> = ContentAPI.shared.tours

class PickTourViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
     var guide: String!
    

    @IBOutlet var tourTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tourTableView.dataSource = self;
        tourTableView.delegate = self
        
        
        setUpTopBar()
        
        // Do any additional setup after loading the view.
    }
    
    func setUpTopBar() {
        self.navigationItem.title = "Start een tour"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tours.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tourCell", for: indexPath) as! TourTableViewCell
        
        let imageArray = ["p00001lockedtour", "p00003unlockedtour", "p00002lockedtour", "p00001unlockedtour", "p00002lockedtour", "p00003lockedtour", "p00001lockedtour"]
        
        let currentTour = tours[indexPath.row]

        if currentTour.highlighted == true {
            cell.backgroundColor = UIColor(red:0.98, green:0.33, blue:0.49, alpha:1.00)
            cell.newView.isHidden = false
        }
        
        
        
    


        cell.tourTitle.text = currentTour.title
        cell.tourText.text = currentTour.text
        cell.tourImage.image = UIImage(named: imageArray[indexPath.row])

        let number = Int(arc4random_uniform(4))
        
        print("partof:\(number)")
        if number%2  == 0 {
           cell.completedImage.image = UIImage(named: "3collected")
        } else {
            cell.completedImage.image = UIImage(named: "4collected")
        }
        
        if currentTour.highlighted == true {
            cell.tourText.textColor = UIColor.white
        } else {
            cell.tourText.textColor = UIColor(red:0.55, green:0.55, blue:0.55, alpha:1.00)
        }
        

//        for paint in currentTour.paintings {
//            print("\(paintings[paint]!)\(currentTour.title)")
//        }
        
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    


    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "backToMap" {
            
            let selectedIndexPath = tourTableView.indexPathForSelectedRow

            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            let activeTour = ActiveTour(context: context)
            activeTour.tourId = tours[(selectedIndexPath?.row)!].id

            
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}

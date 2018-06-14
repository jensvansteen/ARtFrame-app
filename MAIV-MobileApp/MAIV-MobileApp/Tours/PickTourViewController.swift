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
    
//    var tours: Dictionary<String, Tour> = ContentAPI.shared.tours
//    var tourKeys: Array<String> = ContentAPI.shared.tourKeys
//    var paintings: Dictionary<String, Painting> = ContentAPI.shared.paintings
    
//     var tourKeys = Array(tours.keys)
    
    
    @IBOutlet var tourTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tourTableView.dataSource = self;
        tourTableView.delegate = self
        
        
        setUpTopBar()
        
        
//        loadJSON()

        // Do any additional setup after loading the view.
    }
    
    func setUpTopBar() {
        self.navigationItem.title = "Plan je tour"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
//    func loadJSON() {
//        //offline
//        let path = Bundle.main.path(forResource: "tours", ofType: "json")
//        let url: URL = URL(fileURLWithPath: path!)
//
//        let loadingTask = URLSession.shared.dataTask(with: url, completionHandler: completeHandler)
//        loadingTask.resume()
//    }
//
//    func completeHandler(data:Data?, response:URLResponse?, error:Error?) {
//
//        //        let parsedData = String.init(data: data!, encoding: String.Encoding.utf8)
//
//
//        let decoder = JSONDecoder()
//
//        do {
//            let tourList = try decoder.decode(Tours.self, from: data!)
//            tours = tourList.tours
//            DispatchQueue.main.async {
//                self.tourTableView.reloadData()
//            }
//        } catch let error {
//            print(error)
//        }
//
//
//    }
    
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

        cell.tourCompleted.text = "\(String(currentTour.completed))/\(4)"

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
            
            
            
//
//            let sortedKeys = tourKeys.sorted()
//
//            let theSelectedTour = tours[sortedKeys[(selectedIndexPath?.row)!]]!
//
//            let selectedGuide = guide
//
//            mapVC.selectedTour = theSelectedTour
            
//            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//            context.delete(task)
            
            


           
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}

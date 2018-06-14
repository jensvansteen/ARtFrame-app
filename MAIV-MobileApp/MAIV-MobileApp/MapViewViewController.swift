//
//  MapViewViewController.swift
//  MAIV-MobileApp
//
//  Created by Jens Van Steen on 07/06/2018.
//  Copyright © 2018 Team 7 - MAIV. All rights reserved.
//

import UIKit

var paintings : Array<Painting> = ContentAPI.shared.paintings

class MapViewViewController: UIViewController {
    
    @IBOutlet var stopTourButton: UIBarButtonItem!
    @IBOutlet var collectedIndicator: UIBarButtonItem!
    @IBOutlet var tourOrGuideLabel: UILabel!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var activeSelectedTours: [ActiveTour] = []
    
    var activeSelectedGuides: [ActiveGuide] = []
    
    var checkedPaintings: [PaintingChecked] = []
    
    var selectedTour : Tour?
    var selectedGuide : Guide?
    var inTour : Bool = false
    
    
    @IBOutlet var tourOrGuideButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTopBar()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        getData()
        
        if activeSelectedTours.count != 0 && activeSelectedGuides.count != 0 {
            setUpTour(inTour: true)
        } else {
            setUpTour(inTour: false)
        }
        
    }
    
    func setUpTopBar() {
        
        collectedIndicator.title = "\(checkedPaintings.count)/\(paintings.count)"
        
    }
    
    func getCheckedPaintings() -> Int {
        
//        var collectedCount : [PaintingChecked] = []
        
        var paintingsInTour : [PaintingChecked] = []
        
        for paint in selectedTour!.paintings {
            
            paintingsInTour = checkedPaintings.filter { $0.paintingId == paint }
        }
       
        return paintingsInTour.count
    }
    
    
    
    
    func setUpTour(inTour: Bool) {
        
        if inTour == true {
            selectedTour = tours.filter { $0.id == activeSelectedTours[0].tourId }[0]
            selectedGuide = guides.filter { $0.id == activeSelectedGuides[0].guideId }[0]
            let imgName = "small-\(selectedGuide!.id)"
            tourOrGuideButton.setImage(UIImage(named: imgName), for: .normal)
            tourOrGuideLabel.text = "Gids"
            let numberOfCheckedPaintings = getCheckedPaintings()
            self.navigationItem.leftBarButtonItem = self.stopTourButton
            self.navigationItem.rightBarButtonItem = self.collectedIndicator
            self.navigationItem.title = selectedTour?.title
            collectedIndicator.title = "\(numberOfCheckedPaintings)/\(selectedTour!.paintings.count)"
        } else if inTour == false {
            self.navigationItem.title = "Boijmans"
            tourOrGuideButton.setImage(UIImage(named: "Tour"), for: .normal)
            tourOrGuideLabel.text = "Tour"
            self.navigationItem.leftBarButtonItem = nil
            self.navigationItem.rightBarButtonItem = nil
        }
    }
    
    func getData() {
        do {
            activeSelectedTours = try context.fetch(ActiveTour.fetchRequest())
            activeSelectedGuides = try context.fetch(ActiveGuide.fetchRequest())
            checkedPaintings = try context.fetch(PaintingChecked.fetchRequest())
        }
        catch {
            print("Fetching Failed")
        }
    }
   
    
    @IBAction func stopTour(_ sender: UIBarButtonItem) {
        
        let guideInSelection = activeSelectedGuides[0]
        let tourInSelection = activeSelectedTours[0]
        context.delete(guideInSelection)
        context.delete(tourInSelection)
        
        self.viewDidLoad()
        self.viewWillAppear(true)
        
    }
    
    
    
//    override func viewDidAppear(_ animated: Bool) {
//        if guideSelected() {
//            print("Er is hier iets geselecteerd")
//            let gidsImage = UIImage(named: "gidsIcon")
//            tourOrGuideButton.setImage(gidsImage, for: .normal)
//        } else {
//            let tourImage = UIImage(named: "Tour")
//            tourOrGuideButton.setImage(tourImage, for: .normal)
//        }
//    }
//
//    func getData() {
//        do {
//            guides = try context.fetch(GuideData.fetchRequest())
//        }
//        catch {
//            print("Fetching Failed")
//        }
//    }
//
//    //Nakijken of er een gids geselecteerd is
//    fileprivate func guideSelected() -> Bool {
//        return UserDefaults.standard.bool(forKey: "guideSelected")
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        
        if segue.identifier == "toArView" {
            let targetVC = segue.destination as! ARViewViewController
            targetVC.selectedGuide = selectedGuide
            targetVC.selectedTour = selectedTour
        }
        
//        if segue.identifier == "toStickerView" {
//            let targetVC = segue.destination as! StickerCollectionViewController
//        }
        
        
    }
    

}

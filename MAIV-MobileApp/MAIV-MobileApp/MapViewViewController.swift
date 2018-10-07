//
//  MapViewViewController.swift
//  MAIV-MobileApp
//
//  Created by Jens Van Steen on 07/06/2018.
//  Copyright © 2018 Team 7 - MAIV. All rights reserved.
//

import UIKit
import MapKit

var paintings : Array<Painting> = ContentAPI.shared.paintings

class MapViewViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet var stopTourButton: UIBarButtonItem!
    @IBOutlet var tourOrGuideLabel: UILabel!
    @IBOutlet var rotterdamMap: MKMapView!
    
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
        
       
        // Do any additional setup after loading the view.
        
        let centrum = CLLocationCoordinate2D(latitude: 51.923592, longitude: 4.468323)
        rotterdamMap.centerCoordinate = centrum
        rotterdamMap.region = MKCoordinateRegion.init(center: centrum, latitudinalMeters: 2000, longitudinalMeters: 2000)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        getData()
        
        if activeSelectedTours.count != 0 && activeSelectedGuides.count != 0 {
            setUpTour(inTour: true)
        } else {
            setUpTour(inTour: false)
        }
        
        setPins()
    }
    

    func setPins() {
        
      rotterdamMap.removeAnnotations(rotterdamMap.annotations)
        
        for painting in paintings {
            let paintingPoint = MKPointAnnotation()
            paintingPoint.coordinate = CLLocationCoordinate2D(latitude: painting.location.lat, longitude: painting.location.long)
            
            var checkedPainting : [PaintingChecked] = []
            
            checkedPainting = checkedPaintings.filter { $0.paintingId == painting.id}
            
            if checkedPainting.count == 0 {
                paintingPoint.title = "Nog niet ontdekt"
                paintingPoint.subtitle = "locked"
            } else {
                paintingPoint.title = painting.name
                paintingPoint.subtitle = "unlocked"
            }
            
           
            rotterdamMap.addAnnotation(paintingPoint)
        }
        
    }
    
    func getCheckedPaintings() -> Int {
        
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
            self.navigationItem.leftBarButtonItem = self.stopTourButton
            self.navigationItem.title = selectedTour?.title
        } else if inTour == false {
            self.navigationItem.title = "ARtFrame"
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
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
         let mijnView = MKAnnotationView()
         mijnView.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        
        
        if (annotation.subtitle! == "locked") {
            mijnView.image = UIImage(named: "notchecked")
        }
        else if (annotation.subtitle! == "unlocked") {
            mijnView.image = UIImage(named: "checked")
        }
        return mijnView
        
        
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        let calloutView = UIView(frame: CGRect(x: -36, y: -35, width: 120, height: 50))
        let circleView = UIView(frame: CGRect(x: 11, y: 2, width: 26, height: 26))
       
        calloutView.roundCorners(UIRectCorner.allCorners, radius: 20)
        circleView.roundCorners(UIRectCorner.allCorners, radius: 100)
        circleView.backgroundColor = UIColor.white

        calloutView.backgroundColor = UIColor.white
        
        let infoDistance = UILabel(frame: CGRect(x: 10, y: 4, width: 100, height: 12))
        infoDistance.text = "2 KM"
        infoDistance.textAlignment = .center
        infoDistance.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        
        let infoWork = UILabel(frame: CGRect(x: 10, y: 12, width: 100, height: 35))
        if view.annotation!.subtitle == "unlocked" {
            infoWork.text = view.annotation!.title!
        } else {
            infoWork.text = "Nog niet ontdekt!"
        }
        infoWork.textAlignment = .center
        infoWork.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        infoWork.numberOfLines = 0
        
        calloutView.addSubview(infoDistance)
        calloutView.addSubview(infoWork)
        view.addSubview(circleView)
        view.addSubview(calloutView)
     

        
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        
        for view in view.subviews {
            view.removeFromSuperview()
        }
        
    }
   
    
    @IBAction func stopTour(_ sender: UIBarButtonItem) {
        
        let guideInSelection = activeSelectedGuides[0]
        let tourInSelection = activeSelectedTours[0]
        context.delete(guideInSelection)
        context.delete(tourInSelection)
        selectedGuide = nil
        selectedTour = nil
        
        self.viewDidLoad()
        self.viewWillAppear(true)
        
    }
    

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
        
    }
    
}

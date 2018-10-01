//
//  TourStep1ViewController.swift
//  MAIV-MobileApp
//
//  Created by Jens Van Steen on 06/06/2018.
//  Copyright © 2018 Team 7 - MAIV. All rights reserved.
//

import UIKit
import ScalingCarousel

class Cell: ScalingCarouselCell {}

var activeSelectedTours: [ActiveTour] = []

var activeSelectedGuides: [ActiveGuide] = []

var selectedGuide : Guide?
var selectedTour : Tour?

var cellInCenter : Int?

let focus = 1

var initialScrollDone = false;

var guides : Array<Guide> = ContentAPI.shared.guides

extension UILabel {
    
    // Pass value for any one of both parameters and see result
    func setLineSpacing(lineSpacing: CGFloat = 0.0, lineHeightMultiple: CGFloat = 0.0) {
        
        guard let labelText = self.text else { return }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.lineHeightMultiple = lineHeightMultiple
        
        let attributedString:NSMutableAttributedString
        if let labelattributedText = self.attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelattributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }
        
        // Line spacing attribute
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        
        self.attributedText = attributedString
    }
}

class GuideSelectionViewController: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var guideInfo: UILabel!
    @IBOutlet weak var guideName: UILabel!
    @IBOutlet var guideSelection: ScalingCarouselView!
    @IBOutlet var viewTitle: UILabel!
    @IBOutlet var stopTourButton: UIButton!
    @IBOutlet var selectButton: UIButton!
    @IBOutlet var changeButton: UIButton!
    
    
    let screenSize = Int(UIScreen.main.bounds.width)
    
    private struct Constants {
        static let carouselHideConstant: CGFloat = -50
        static let carouselShowConstant: CGFloat = 45
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        checkData()
        
        layOutUi()
        
    }
    
    
    override func viewWillDisappear(_ animated : Bool) {
        super.viewWillDisappear(animated)
        
        initialScrollDone = false
        
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
        
        if initialScrollDone == false {
            initialScrollDone = true;
            
            if selectedGuide != nil {
                scrollToIndex(index: selectedGuide!.index)
                setGuideInfo(index: selectedGuide!.index)
            } else {
                scrollToIndex(index: focus)
                setGuideInfo(index: focus)
            }
            
        }
        
        
    }
    
    func layOutUi() {
        
        if activeSelectedTours.count != 0 && activeSelectedGuides.count != 0 {
            self.navigationItem.title = selectedTour!.title
            viewTitle.text = "Kies je gids"
            changeButton.isHidden = false
            selectButton.isHidden = true
        } else {
            stopTourButton.isHidden = true
            selectButton.isHidden = false
            changeButton.isHidden = true
            viewTitle.text = "Stap 1 : kies je gids"
            self.navigationItem.title = "Plan je tour"
            navigationItem.backBarButtonItem = UIBarButtonItem(title: "Stap 1", style: .plain, target: nil, action: nil)
        }
    }
    
    func checkData() {
        
        do {
            activeSelectedTours = try context.fetch(ActiveTour.fetchRequest())
            activeSelectedGuides = try context.fetch(ActiveGuide.fetchRequest())
        }
        catch {
            print("Fetching Failed")
        }
        
        
        if activeSelectedGuides.count != 0 && activeSelectedTours.count != 0 {
            selectedGuide = guides.filter { $0.id == activeSelectedGuides[0].guideId}[0]
            selectedTour = tours.filter { $0.id == activeSelectedTours[0].tourId }[0]
        } else {
            cellInCenter = 1
        }
        
        
    }
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        guideSelection.deviceRotated()
    }
    
    func scrollToIndex(index: Int) {
        let indexPath = NSIndexPath(item: index, section: 0)
        guideSelection?.scrollToItem(at: indexPath as IndexPath, at: .right, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    @IBAction func stopTour(_ sender: UIButton) {
        let guideInSelection = activeSelectedGuides[0]
        let tourInSelection = activeSelectedTours[0]
        context.delete(guideInSelection)
        context.delete(tourInSelection)
        
        initialScrollDone = false
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func selectGuide(_ sender: UIButton) {
        
        if selectedGuide != nil && selectedTour != nil {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            let guideInSelection = activeSelectedGuides[0]
            context.delete(guideInSelection)
            
            let activeGuide = ActiveGuide(context: context)
            activeGuide.guideId = guides[cellInCenter!].id
            
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    func setGuideInfo(index: Int) {
        guideName.text = guides[index].fullName
        guideInfo.text = guides[index].info
        guideInfo.setLineSpacing(lineSpacing: 5)
        guideInfo.textAlignment = .center
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        initialScrollDone = false
        
        if segue.identifier == "toTour" {
            
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            let activeGuide = ActiveGuide(context: context)
            activeGuide.guideId = guides[cellInCenter!].id
            
        }
    }
    
}


typealias CarouselDatasource = GuideSelectionViewController
extension CarouselDatasource: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return guides.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        let guide = guides[indexPath.row].id
        
        let image = UIImage(named: guide)
        let imageView = UIImageView(image: image!)
        
        var myNewView = UIView(frame: CGRect(x: 0, y: 0, width: 250, height: 250))
        
        switch screenSize {
        case 320:
            imageView.frame = CGRect(x: 3, y: 0, width: 250, height: 250)
            myNewView=UIView(frame: CGRect(x: 0, y: 0, width: 250, height: 250))
        case 375:
            imageView.frame = CGRect(x: 3, y: 0, width: 250, height: 250)
            myNewView=UIView(frame: CGRect(x: 0, y: 0, width: 250, height: 250))
        case 414:
            imageView.frame = CGRect(x: -2.5, y: 0, width: 300, height: 300)
            myNewView=UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        default:
            imageView.frame = CGRect(x: 3, y: 0, width: 250, height: 250)
            myNewView=UIView(frame: CGRect(x: 0, y: 0, width: 250, height: 250))
        }
        
        myNewView.addSubview(imageView)
        
        if let scalingCell = cell as? ScalingCarouselCell {
            scalingCell.clipsToBounds = false
            scalingCell.mainView.addSubview(myNewView)
        }
        
        DispatchQueue.main.async {
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
        }
        
        cell.layer.masksToBounds = false
        //        cell.layer.cornerRadius = cell.frame.size.width / 2
        cell.clipsToBounds = false;
        
        return cell
    }
}


typealias CarouselDelegate = GuideSelectionViewController
extension GuideSelectionViewController: UICollectionViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //carousel.didScroll()
        
        guard let currentCenterIndex = guideSelection.currentCenterCellIndex?.row else { return }
        
        
        cellInCenter = Int(currentCenterIndex)
        
        print(cellInCenter!)
        
        setGuideInfo(index: Int(currentCenterIndex))
    }
    
}

private typealias ScalingCarouselFlowDelegate = GuideSelectionViewController
extension ScalingCarouselFlowDelegate: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
}

 



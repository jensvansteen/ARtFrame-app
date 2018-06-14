//
//  StickerCollectionViewController.swift
//  MAIV-MobileApp
//
//  Created by Jens Van Steen on 08/06/2018.
//  Copyright © 2018 Team 7 - MAIV. All rights reserved.
//

import UIKit

class StickerCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet var stickerCollection: UICollectionView!
    @IBOutlet var collectedLabel: UILabel!
    
    var checkedPaintings: [PaintingChecked] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stickerCollection.delegate = self
        stickerCollection.dataSource = self
        
        
        setUPTopBar()

        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        getData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUPTopBar() {
        self.navigationItem.title = "Jouw stickers"
        navigationItem.backBarButtonItem = UIBarButtonItem(title:"back", style: .plain, target: nil, action: nil)
        collectedLabel.text = "\(checkedPaintings.count)/\(paintings.count)"
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return paintings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "stickerCell", for: indexPath) as! StickerCollectionViewCell
        
        let currentSticker = paintings[indexPath.row]
        
        let checkIfCollected = checkedPaintings.filter { $0.paintingId == currentSticker.id}
        
        if checkIfCollected.count == 0 {
            let imagename = "\(currentSticker.id)lockedcollection"
            cell.stickerImage.image = UIImage(named: imagename)
        } else {
            let imagename = "\(currentSticker.id)unlockedcollection"
            cell.stickerImage.image = UIImage(named: imagename)
        }
    
        return cell
    }
    
    func getData() {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do {
            checkedPaintings = try context.fetch(PaintingChecked.fetchRequest())
        }
        catch {
            print("Fetching Failed")
        }
        
         setUPTopBar()
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let detailVC = segue.destination as! StickerDetailViewController
        
        if let sender = sender as? UICollectionViewCell {
            
            let stickerIndex = stickerCollection.indexPath(for: sender)
            
            let selectedSticker = paintings[(stickerIndex?.row)!]
            
             let checkIfCollected = checkedPaintings.filter { $0.paintingId == selectedSticker.id}
            
            var isCollected = false
            
            if checkIfCollected.count == 0 {
                isCollected = false
            } else {
                isCollected = true
            }
            
            // Whatever else you want to do
            detailVC.collectStatus = isCollected
            detailVC.selectedSticker = selectedSticker
        }
        
        
        
        
    }
}

//
//  ARViewViewController.swift
//  MAIV-MobileApp
//
//  Created by Jens Van Steen on 09/06/2018.
//  Copyright © 2018 Team 7 - MAIV. All rights reserved.
//

import UIKit
import SceneKit
import ARKit



class ARViewViewController: UIViewController, ARSCNViewDelegate {
    
    var selectedGuide : Guide?
    var selectedTour : Tour?
    var scannendPainting : Painting?
    
    var player = AVPlayer()
    
     var checkedPaintings: [PaintingChecked] = []

    func changeArtwork() {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        DispatchQueue.main.async { // Make sure you're on the main thread here
            self.navigationItem.title = self.scannendPainting!.name
        }
        
        
        let checkedScannendPaintings = checkedPaintings.filter { $0.paintingId == scannendPainting!.id}
        
        if checkedScannendPaintings.count == 0 {
            let collectedPainting = PaintingChecked(context: context)
            collectedPainting.paintingId = scannendPainting!.id
            print(checkedPaintings.count)
        } else {
            print(checkedPaintings.count)
        }
        
     
      
        let CVC = children.last as! OverVIewARViewController
        CVC.scannendPainting = scannendPainting!
        CVC.updateSelf()
    }
    
    @IBOutlet var sceneView: ARSCNView!
    
   
//    let contentFor = [
//        "piettrot" : ["artWorkName": "Pierrot and Guitar", "artistName": "Gino Severini"]
//    ]
    
    let updateQueue = DispatchQueue(label: Bundle.main.bundleIdentifier! +
        ".serialSceneKitQueue")
    
    var session: ARSession {
        return sceneView.session
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        sceneView.showsStatistics = true
        
        addPullUpController()
        
        let scene = SCNScene()
        
        sceneView.scene = scene
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIApplication.shared.isIdleTimerDisabled = true
        
        resetTracking()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getData()
        
        //Loop video of artwork
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.player.currentItem, queue: .main) { _ in
            self.player.seek(to: CMTime.zero)
            self.player.play()
        }
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        configuration.detectionImages = ARReferenceImage.referenceImages(inGroupNamed: "paintings", bundle: nil)
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    func resetTracking() {
        
        guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "paintings", bundle: nil) else {
            fatalError("Missing expected asset catalog resources. Not good!!!!!!!!!!!!")
        }
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.detectionImages = referenceImages
        session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        
    }
    
    //Add view with information about work
    private func addPullUpController() {
        guard
            let pullUpController = UIStoryboard(name: "Main", bundle: nil)
                .instantiateViewController(withIdentifier: "OverVIewARViewController") as? OverVIewARViewController
            else { return }
        
        pullUpController.selectedGuide = selectedGuide
        pullUpController.selectedTour = selectedTour
        
        addPullUpController(pullUpController)
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        guard let imageAnchor = anchor as? ARImageAnchor else {return}
        let image = imageAnchor.referenceImage
        
        print(image.name!)
        print("rednering works")
        scannendPainting = paintings.filter { $0.id == image.name }[0]
        changeArtwork()
        
        let videoName = scannendPainting!.id
        
        let urlString = Bundle.main.path(forResource: videoName, ofType: "mp4")
        
        let url = URL(fileURLWithPath: urlString!)
        
        let item = AVPlayerItem(url: url)
        
        player = AVPlayer(playerItem: item)
        
        let videoNode = SKVideoNode(avPlayer: player)
        videoNode.play()
        
        let skScene = SKScene(size: CGSize(width: 1050, height: 1350))
        skScene.addChild(videoNode)
        skScene.backgroundColor = .clear
        skScene.scaleMode = .aspectFit
        
        videoNode.position = CGPoint(x: skScene.size.width / 2.0, y: skScene.size.height / 2.0)
        videoNode.size = skScene.size
        
        let videoPlane = SCNPlane(width: image.physicalSize.width, height: image.physicalSize.height)
        
        videoPlane.firstMaterial?.diffuse.contents = skScene
        videoPlane.firstMaterial?.isDoubleSided = true
        
        let backgroundNode = SCNNode(geometry: videoPlane)
        
        backgroundNode.eulerAngles.x = .pi / 2
        
        node.addChildNode(backgroundNode)
        
    }
    
    func getData() {
        
       let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do {
            checkedPaintings = try context.fetch(PaintingChecked.fetchRequest())
        }
        catch {
            print("Fetching Failed")
        }
    }
    

    
 
    // MARK: - ARSCNViewDelegate
    
    /*
     // Override to create and configure nodes for anchors added to the view's session.
     func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
     let node = SCNNode()
     
     return node
     }
     */
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}


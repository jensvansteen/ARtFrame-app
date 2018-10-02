//
//  OverVIewARViewController.swift
//  MAIV-MobileApp
//
//  Created by Jens Van Steen on 09/06/2018.
//  Copyright © 2018 Team 7 - MAIV. All rights reserved.
//

import UIKit
import AVFoundation

var artists : Array<Artist> = ContentAPI.shared.artists

extension UIView {
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
}

class OverVIewARViewController: PullUpController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var selectedGuide : Guide?
    var selectedTour : Tour?
    var scannendPainting : Painting?
    
//    var checkedPaintings: [PaintingChecked] = []
    
    var voiceToUse : AVSpeechSynthesisVoice?
    
    var siri = AVSpeechSynthesizer()

    @IBOutlet var mainView: UIView!
    @IBOutlet var topView: UIView!
    @IBOutlet var bottomView: UIView!
    @IBOutlet weak var nameArtwork: UILabel!
    @IBOutlet var nameArtist: UILabel!
    @IBOutlet var buttonMoveUp: UIButton!
    @IBOutlet var chatView: UIView!
    @IBOutlet var quistionView: UIView!
    @IBOutlet var guideName: UILabel!
    @IBOutlet var guideImage: UIImageView!
    @IBOutlet var answer: UILabel!
    @IBOutlet var quistion: UILabel!
    @IBOutlet var closeButton: UIButton!
    @IBOutlet var questionCollection: UICollectionView!
    @IBOutlet var goBackView: UIView!
    @IBOutlet var goGuidesButton: UIButton!
    @IBOutlet var questionVIew: UIView!
    @IBOutlet var muteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.roundCorners([.topLeft, .topRight], radius: 40)
        quistionView.roundCorners([.topLeft, .topRight], radius: 40)
        
        // Do any additional setup after loading the view.
        
        self.didMoveToStickyPoint = { point in
            print("didMoveToStickyPoint \(point)")
        }
        
        self.willMoveToStickyPoint = { point in
            print("willMoveToStickyPoint \(point)")
            if point == 392.0 {
                self.popUp()
            } else if point == 85.0 {
                self.dropDown()
            }
        }
       
        
    
        setMuteButton()
            
        
        selectVoice()
       
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        siri.stopSpeaking(at: .word)
    }
    
    func setMuteButton() {
        let muted = UserDefaultPresent(key: "muted")
        
        if !muted {
            UserDefaults.standard.set(true, forKey: "muted")
        }
        
        let muteStatus = UserDefaults.standard.bool(forKey: "muted")
        muteStatus ? muteButton.setImage(UIImage(named: "sound-on"), for: UIControl.State.normal) : muteButton.setImage(UIImage(named: "sound-off"), for: UIControl.State.normal)
    }
    
    func UserDefaultPresent(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: "muted") != nil
    }
    
    
    func selectVoice() {
        
        var womanVoice = false
        
        if selectedGuide?.id == "g02" {
            womanVoice = true
        } else {
            womanVoice = false
        }
        
        
        for voice in AVSpeechSynthesisVoice.speechVoices() {
            if #available(iOS 11.3, *) {
                // use the name that you want to use from array. e.g.- "Karen"
                
                if voice.name == "Xander" && womanVoice == false {
                    voiceToUse = voice
                } else if voice.name == "Ellen" && womanVoice == true {
                    voiceToUse = voice
                }
            }
        }
        
    }
    
    func sayWords(what description: String) {
        siri.stopSpeaking(at: .word)
        let comntent = AVSpeechUtterance(string: description)
        comntent.voice = voiceToUse
        siri.speak(comntent)
    }
    
    override func viewWillAppear(_ animated: Bool) {
//         getData()
        
        
        setUpUi()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var pullUpControllerPreferredSize: CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: bottomView.frame.maxY)
    }
    
    override var pullUpControllerPreviewOffset: CGFloat {
        return topView.frame.height
    }
    
    func ChangeLabel(artworkNameToChange : String, artistNameToChange: String){
        
        DispatchQueue.main.async { // Make sure you're on the main thread here
            self.nameArtwork.text = artworkNameToChange
            self.nameArtist.text = artistNameToChange
        }
        
        
        
    }
    
    func updateSelf() {
        DispatchQueue.main.async { // Make sure you're on the main thread here
            let artistName = artists.filter { $0.id == self.scannendPainting!.artistid}[0]
            self.nameArtist.text = artistName.name
            self.nameArtwork.text = self.scannendPainting!.name
            self.questionCollection.reloadData()
//
        }
    }
    
    func setUpUi() {
        
        if selectedGuide != nil {
            guideName.text = selectedGuide!.name
            let imageName = "small-\(selectedGuide!.id)"
            guideImage.image =  UIImage(named: imageName)
        } else {
            goBackView.isHidden = false
            guideName.isHidden = true
            guideImage.isHidden = true
            chatView.isHidden = true
        }
      
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var total = 0
        
        if scannendPainting != nil && selectedGuide != nil {
            let questionNumber = scannendPainting!.questions
            total = questionNumber.count
        } else {
           total = 0
        }
        
        return total
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "quistionCell", for: indexPath) as! QuestionUICollectionViewCell
        
        
        
//        print(scannendPainting?.questions[indexPath].["question"])
        
        if selectedGuide != nil {
            let qes = scannendPainting?.questions[indexPath.row].question
            
            cell.questionCell.setTitle(qes, for: .normal)
            
            cell.callBack = { [weak self] collectionViewCell in
                let indexPath = collectionView.indexPath(for: collectionViewCell!)
                self?.showAnswer(pat: indexPath!)
            }
        }
        
        
       
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if scannendPainting?.questions[indexPath.row].question != nil {
            
            let size = CGSize(width: 200, height: 40)
            
            let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)]
            
            let estimedSizeText = NSString(string: scannendPainting!.questions[indexPath.row].question).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
            
            print("the size is \(estimedSizeText)")
            
            return CGSize(width: estimedSizeText.width + 20, height: 40)
        }
        return CGSize(width: 40, height: 40)
    }
    
    func showAnswer(pat: IndexPath) {
        questionVIew.isHidden = false
      let guideid = selectedGuide!.id
      let questionObject = scannendPainting!.questions[pat.row]
      var answerForQes = "niets"
      quistion.text = questionObject.question
      questionVIew.layer.cornerRadius = self.quistion.frame.height * 0.9
        print("het is dus zo breed\(quistion.frame.width)");
        switch guideid {
        case "g01":
            answerForQes = questionObject.g01
        case "g02":
            answerForQes = questionObject.g02
        case "g03":
            answerForQes = questionObject.g03
        default:
            print("something not right")
        }
        
        answer.text = answerForQes
        if (UserDefaults.standard.bool(forKey: "muted")) {
           sayWords(what: answerForQes)
        }
    }
    
    @IBAction func goToGuides(_ sender: Any) {
        print("kom ga is naar de gidsen")
    }
    
    func printSome() {
        print("whatss uuuuuupppp")
    }
    
    
    func popUp() {
        print("check yourself")
        
        
        topView.isHidden = true
        chatView.isHidden = false
        topView.isUserInteractionEnabled = false
        chatView.isUserInteractionEnabled = true
        mainView.backgroundColor = UIColor(red:0.90, green:0.90, blue:0.90, alpha:1.00)
    }
    
    func dropDown() {
        print("downBown")
        
        chatView.isHidden = true
        topView.isHidden = false
        topView.isUserInteractionEnabled = true
        chatView.isUserInteractionEnabled = false
        mainView.backgroundColor = UIColor.white
    }


    @IBAction func moveUp(_ sender: UIButton) {
      self.pullUpControllerMoveToVisiblePoint(392, completion: nil)
      self.popUp()
    }
    
    @IBAction func moveDown(_ sender: UIButton) {
        self.pullUpControllerMoveToVisiblePoint(85, completion: nil)
        self.dropDown()
    }
    
    
    @IBAction func muteSound(_ sender: UIButton) {
        
        if UserDefaultPresent(key: "muted") {
            siri.stopSpeaking(at: .word)
            let muteStatus = UserDefaults.standard.bool(forKey: "muted")
            UserDefaults.standard.set(!muteStatus, forKey: "muted")
        }
        
        setMuteButton()
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

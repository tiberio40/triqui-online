//
//  MultiPlayerController.swift
//  triqui
//
//  Created by Laurent castañeda ramirez on 29/10/19.
//  Copyright © 2019 Laurent castañeda ramirez. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseFirestore

class MultiPlayerController: UIViewController {
    
    var db: Firestore!
    
    @IBOutlet var button_0: UIButton!
    @IBOutlet var button_1: UIButton!
    @IBOutlet var button_2: UIButton!
    @IBOutlet var button_3: UIButton!
    @IBOutlet var button_4: UIButton!
    @IBOutlet var button_5: UIButton!
    @IBOutlet var button_6: UIButton!
    @IBOutlet var button_7: UIButton!
    @IBOutlet var button_8: UIButton!
    @IBOutlet var infoMessage: UILabel!
    
    
    var idDocument: String?
    var arrayUI: [UIButton] = []
    var whoPlayerAmI: Bool = true;
    var model: MultiPlayerModelView?
    var deviceId: String = ""
    var arrayPlay: [[String]] = []
    
    
    override func viewDidLoad() {
        
        self.arrayUI.append(self.button_0)
        self.arrayUI.append(self.button_1)
        self.arrayUI.append(self.button_2)
        self.arrayUI.append(self.button_3)
        self.arrayUI.append(self.button_4)
        self.arrayUI.append(self.button_5)
        self.arrayUI.append(self.button_6)
        self.arrayUI.append(self.button_7)
        self.arrayUI.append(self.button_8)
        
        arrayPlay.append(["", "",""])
        arrayPlay.append(["", "",""])
        arrayPlay.append(["", "",""])
        
        super.viewDidLoad()
        
        self.deviceId = UIDevice.current.identifierForVendor!.uuidString
        
        let settings = FirestoreSettings()
        
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        
        db.collection("playroom").document(self.idDocument!)
            .addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                
                guard let data = document.data() else {
                    print("Document data was empty.")
                    return
                }
                self.model = MultiPlayerModelView(diccionary: data)
                self.setPlayed(model: self.model!)
                self.setPlayer(model: self.model!)
                if(self.model!.message != 0){
                    DispatchQueue.main.async {
                        if(self.whoPlayerAmI){
                            self.infoMessage.text = "Jugador 1 Gana"
                        }else{
                            self.infoMessage.text = "Jugador 2 Gana"
                        }
                    }
                }
                self.setEnableButton()
                
        }
    }
    
    @IBAction func userEvent(_ sender: Any) {
        guard let button = sender as? UIButton else {
            return
        }
        
        let image = UIImage(named: self.whoPlayerAmI == true ? "equis": "circle") as UIImage?
        //        let image = UIImage(named: "equis") as UIImage?
        
        self.imageButton(image: image!, index: button.tag)
    }
    
    func imageButton(image: UIImage, index:Int){
        var button = self.model!.buttons
        if(self.whoPlayerAmI){
            button![index] = 1
        }else{
            button![index] = 2
        }
        let washingtonRef = db.collection("playroom").document(self.idDocument!)
        
        self.model!.turn = !self.model!.turn
        // Set the "capital" field of the city 'DC'
        washingtonRef.updateData([
            "buttons": button!,
            "turn": self.model!.turn
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                DispatchQueue.main.async {
                    self.arrayUI[index].setImage(image, for: .normal)
                    self.setEnableButton()
                    self.CheckForWinning()
                }
            }
        }
        
        
    }
    
    @IBAction func NewGame(_ sender: Any) {
        self.db.collection("playroom").document(self.idDocument!).updateData([
            "buttons": [0, 0, 0, 0, 0, 0, 0, 0, 0],
            "turn": self.whoPlayerAmI
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                self.setEnableButton()
                self.model!.turn = self.whoPlayerAmI
            }
        }
    }
    
    
    func setPlayed(model: MultiPlayerModelView){
        for (index, element) in self.model!.buttons!.enumerated(){
            switch element {
            case 0:
                DispatchQueue.main.async {
                    self.arrayUI[index].setImage(nil, for: .normal)
                }
            case 1:
                let image = UIImage(named: "equis") as UIImage?
                DispatchQueue.main.async {
                    self.arrayUI[index].setImage(image, for: .normal)
                }
            case 2:
                let image = UIImage(named: "circle") as UIImage?
                DispatchQueue.main.async {
                    self.arrayUI[index].setImage(image, for: .normal)
                }
            default:
                print("no encontro")
            }
        }
    }
    
    func setPlayer(model: MultiPlayerModelView){
        var user: [String: String]
        if(self.model!.player1 == "" || self.model!.player1 == self.deviceId){
            self.infoMessage.text = "Jugador 1"
            user = ["player1":self.deviceId]
            self.whoPlayerAmI = true
            
        }else{
            self.infoMessage.text = "Jugador 2"
            user = ["player2":self.deviceId]
            self.whoPlayerAmI = false
        }
        
        self.db.collection("playroom").document(self.idDocument!).updateData(user) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                
            }
        }
    }
    
    func setEnableButton(){
        if(self.whoPlayerAmI == self.model!.turn){
            for value in self.arrayUI{
                value.isEnabled = true
            }
        }else{
            for value in self.arrayUI{
                value.isEnabled = false
            }
        }
    }
    
    func CheckForWinning(){
        let player = self.deviceId
        var winning: Bool = false
        var isWinning: Int = 0
        
        for row in 0...2{
            for column in 0...2{
                if(arrayPlay[row][column] == player){
                    isWinning+=1
                }
            }
            if(isWinning == 3){
                winning = true
                break
            }else{
                isWinning = 0
            }
        }
        
        if(!winning){
            isWinning = 0
            
            for column in 0...2{
                for row in 0...2{
                    if(arrayPlay[row][column] == player){
                        isWinning+=1
                    }
                }
                if(isWinning == 3){
                    winning = true
                    break
                }else{
                    isWinning = 0
                }
            }
        }
        
        
        if(!winning && arrayPlay[0][0] == player && arrayPlay[1][1] == player && arrayPlay[2][2] == player ){
            winning = true
        }
        
        if(!winning && arrayPlay[0][2] == player && arrayPlay[1][1] == player && arrayPlay[2][0] == player ){
            winning = true
        }
        
        if(winning){
            self.db.collection("playroom").document(self.idDocument!).updateData([
                "message": whoPlayerAmI == true ? 1: 2]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    
                }
            }
        }
        
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

//
//  PlayListController.swift
//  triqui
//
//  Created by Laurent castañeda ramirez on 29/10/19.
//  Copyright © 2019 Laurent castañeda ramirez. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseFirestore

class PlayListController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var db: Firestore!
    @IBOutlet var table: UITableView!
    
    var playroomList = [String]()
    var indexRowSelected: Int = 0
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.table.dataSource = self
        self.table.delegate = self
        
        // Do any additional setup after loading the view.
        let settings = FirestoreSettings()
        
        Firestore.firestore().settings = settings
        // [END setup]
        db = Firestore.firestore()
        
        
        db.collection("playroom").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    self.playroomList.append(document.documentID)
                }
                self.table.reloadData()
                //self.LoadTable()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.playroomList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        cell?.textLabel?.text = self.playroomList[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.indexRowSelected = indexPath.row
        self.performSegue(withIdentifier: "multiplayer", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "multiplayer"{
            let multiplayer : MultiPlayerController = segue.destination as! MultiPlayerController
            multiplayer.idDocument = self.playroomList[self.indexRowSelected]
            
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

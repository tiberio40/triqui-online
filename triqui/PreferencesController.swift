//
//  PreferencesController.swift
//  triqui
//
//  Created by Laurent castañeda ramirez on 10/6/19.
//  Copyright © 2019 Laurent castañeda ramirez. All rights reserved.
//

import UIKit

class PreferencesController: UITableViewController {
    
    @IBOutlet weak var checkedButton: UIButton!
    @IBOutlet weak var DificultyMessage: UILabel!
    @IBOutlet weak var VictoryMenssageLabel: UILabel!
    
    
    var isSoundChecked: Bool = true
    var lvlDifficulty: Int = 1
    var victoryMessage: String = "ha ganado"
    var principalController: ViewController?

    override func viewDidLoad() {
        self.VictoryMenssageLabel.text? = self.victoryMessage
        if(self.victoryMessage == "ha ganado"){
            self.VictoryMenssageLabel.text = "Predeterminado"
        }else{
            self.VictoryMenssageLabel.text = self.victoryMessage
        }
        
        if(!self.isSoundChecked){
            self.checkedButton.setImage(UIImage(named: "UnCheckd"), for: .normal)
        }else{
            self.checkedButton.setImage(UIImage(named: "Cheked"), for: .normal)
        }
        
        self.setPointMessage()
        
        
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
 

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }
    
    @IBAction func SoundActivated(_ sender: Any) {
        if(self.isSoundChecked){
            self.checkedButton.setImage(UIImage(named: "UnCheckd"), for: .normal)
        }else{
            self.checkedButton.setImage(UIImage(named: "Cheked"), for: .normal)
        }
        self.isSoundChecked = !self.isSoundChecked
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 1:
            let alert = UIAlertController(title: "Mensaje de Victoria", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))

            alert.addTextField(configurationHandler: { textField in
                textField.placeholder = "Ingresa tu mensaje..."
            })

            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in

                if let message = alert.textFields?.first?.text {
                    self.victoryMessage = message
                    self.VictoryMenssageLabel.text = message
                }
            }))

            self.present(alert, animated: true)
        case 2:
            let alert = UIAlertController(title: "Nivel de Dificultad", message: "Por favor escoge un nivel de dificultad", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Facil", style: .default, handler: { (_) in
                self.lvlDifficulty = 1
                self.DificultyMessage.text = "Facil"
            }))
            
            alert.addAction(UIAlertAction(title: "Mediano", style: .default, handler: { (_) in
                self.lvlDifficulty = 2
                self.DificultyMessage.text = "Mediano"
            }))
            
            alert.addAction(UIAlertAction(title: "Experto", style: .default, handler: { (_) in
                self.lvlDifficulty = 3
                self.DificultyMessage.text = "Experto"
            }))
            
            alert.addAction(UIAlertAction(title: "Salir", style: .cancel, handler: { (_) in

            }))
            
            self.present(alert, animated: true, completion: nil)
        case 3:
            principalController?.isSave = true
            principalController?.isSoundChecked = self.isSoundChecked
            principalController?.lvlDifficulty = self.lvlDifficulty
            principalController?.victoryMessage = self.victoryMessage
            self.navigationController?.popViewController(animated: true)
        default:
            print("")
        }
        //...
    }
    
    func setPointMessage(){
        var difficulty: String = ""
        switch lvlDifficulty {
        case 1:
            difficulty = "Facil"
            break
        case 2:
            difficulty = "Mediano"
            break
        case 3:
            difficulty = "Experto"
            break
        default:
            difficulty = "Facil"
            break
        }
        self.DificultyMessage.text = difficulty
    }
    
    
    

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

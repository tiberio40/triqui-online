//
//  MultiplayerModel.swift
//  triqui
//
//  Created by Laurent castañeda ramirez on 29/10/19.
//  Copyright © 2019 Laurent castañeda ramirez. All rights reserved.
//

import Foundation

struct MultiPlayer: Codable {
    var buttons: [Int]?
}

class MultiPlayerModelView  {
    
    public var player1: String = ""
    public var player2: String = ""
    public var buttons: [Int]?
    public var turn: Bool = true
    public var message: Int = 0
    
    init(diccionary: [String : Any]) {
        for (key,value) in diccionary {
            if(key == "buttons"){
                self.buttons = value as! [Int]
            }
            
            if(key == "turn"){
                self.turn = value as! Bool
            }
            
            if(key == "player1"){
                self.player1 = value as! String
            }
            
            if(key == "player2"){
                self.player2 = value as! String
            }
            
            if(key == "message"){
                self.message = value as! Int
            }
        }
    }
}

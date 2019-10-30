//
//  Play.swift
//  triqui
//
//  Created by Laurent castañeda ramirez on 10/1/19.
//  Copyright © 2019 Laurent castañeda ramirez. All rights reserved.
//

struct Play {
    
    var state:Int
    
    init(state: Int) {
        self.state = state
    }
    
    
    mutating func editValue(state: Int){
        self.state = state
    }
    
}

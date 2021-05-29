//
//  Record.swift
//  CardsGame
//
//  Created by Amit Kremer  on 22/05/2021.
//

import Foundation

class Record: Codable, Comparable{
    
    var gameDuration: Int = 0
    var Name:String = ""
    var Location:LatLng?
    
    
    init() {
        
    }
    
    init (gameDuration:Int, Name:String, Location:LatLng?){
        self.gameDuration = gameDuration
        self.Name = Name
        self.Location = Location ?? nil
        
    }
    static func == (lhs: Record, rhs: Record) -> Bool {
        return lhs.gameDuration == rhs.gameDuration
    }
    
    static func < (lhs: Record, rhs: Record) -> Bool {
        return (lhs.gameDuration - rhs.gameDuration) > 0
        
    }
}



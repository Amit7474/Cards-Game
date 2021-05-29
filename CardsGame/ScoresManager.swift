//
//  ScoresManager.swift
//  CardsGame
//
//  Created by Amit Kremer  on 22/05/2021.
//

import Foundation

class ScoresManager: NSObject {
    static let instance = ScoresManager()
    var userDefault : UserDefaults?
    var highScores:[Record]?
    
    private override init() {
        super.init()
        userDefault = UserDefaults.standard
        loadHighScores()
    }
    
    func saveHighScores()  {
        highScores?.sort()
        var dataToSave = highScores
        
        if(highScores?.count ?? -1 > 10){
            dataToSave = Array(highScores![0..<10] )
        }
        let jsonData = try!   JSONEncoder().encode(dataToSave )
        let jsonString = String(data: jsonData, encoding: .utf8)!
        userDefault?.set(jsonString, forKey: "memoryGameScores")
        
        
    }
    
    func loadHighScores(){
        if let jsonString = userDefault?.string(forKey: "memoryGameScores") {
            print(jsonString)
            let scores = try! JSONDecoder().decode([Record].self, from: jsonString.data(using: .utf8)!)
            highScores = scores
            highScores?.sort()
        }else {
            highScores = [Record]()
        }
    }
    
    func isNewHighScore(record: Record) -> Bool {
        highScores?.sort()
        if(highScores?.count ?? -1 >= 10){
            return (record.gameDuration - highScores![9].gameDuration) > 0
        }
        return true
    }
    
    func isNewHighScore(gameDuration: Int) -> Bool {
        highScores?.sort()
        if(highScores?.count ?? -1 >= 10){
            return (gameDuration - highScores![9].gameDuration) > 0
        }
        return true
    }
    
    func addNewHighScore(record: Record){
        highScores?.append(record)
        highScores?.sort()
        saveHighScores()
    }
}

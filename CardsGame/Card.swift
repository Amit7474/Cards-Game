//
//  Card.swift
//  CardsGame
//
//  Created by Amit Kremer  on 20/05/2021.
//

import Foundation
import UIKit
class Card {
    var id: String
    var shown: Bool = false
    var artworkURL: UIImage!
    
    init(image: UIImage) {
        self.id = NSUUID().uuidString
        self.shown = false
        self.artworkURL = image
    }
    
    init(card: Card) {
        self.id = card.id
        self.shown = card.shown
        self.artworkURL = card.artworkURL
    }
    
    func equals(_ card: Card) -> Bool {
        return (card.id == id)
    }
    
    func copy() -> Card {
        return Card(card: self)
    }
    
   
}

extension Array {
    mutating func shuffle() {
        for _ in 0...self.count {
            sort { (_,_) in arc4random() < arc4random() }
        }
    }
}

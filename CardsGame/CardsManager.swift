//
//  CardsManager.swift
//  CardsGame
//
//  Created by Amit Kremer  on 22/05/2021.
//
import Foundation
import UIKit
typealias CardsArray = [Card]


class CardsManager {
    

    static let instance = CardsManager()
    
    static var defaultCardImages:[UIImage] = [
        UIImage(named: "1C")!,
        UIImage(named: "2C")!,
        UIImage(named: "3C")!,
        UIImage(named: "4C")!,
        UIImage(named: "5C")!,
        UIImage(named: "6C")!,
        UIImage(named: "7C")!,
        UIImage(named: "8C")!,
        UIImage(named: "9C")!,
        UIImage(named: "10C")!,
        UIImage(named: "11C")!,
        UIImage(named: "12C")!
    ];
    
    func getCardImages(numOfPairs: Int, completion: ((CardsArray?, Error?) -> ())?) {
        var cards = CardsArray()
        let cardImages = CardsManager.defaultCardImages
        
        for i in 0 ..< numOfPairs {
            let card = Card(image: cardImages[i])
            let copy = card.copy()
            
            cards.append(card)
            cards.append(copy)
        }
        
        completion!(cards, nil)
    }
}

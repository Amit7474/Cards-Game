//
//  LatLng.swift
//  CardsGame
//
//  Created by Amit Kremer  on 22/05/2021.
//

import Foundation

class LatLng: Codable {
    var lat : Double = 0
    var lng : Double = 0
    
    init (){}
    
    init (lat: Double, lng: Double)
    {
        self.lat = lat
        self.lng = lng
    }
    public var toString: String {
        return "\(self.lat),\(self.lng)"
    }
}

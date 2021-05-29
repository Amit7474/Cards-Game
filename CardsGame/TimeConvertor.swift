//
//  TimeConvertor.swift
//  Memory Game
//
//  Created by Paz Lavi  on 13/05/2021.
//

import Foundation

class TimeConvertor  {
    static func prettyPrintSecToHHss(_ sec : Int) ->String{
        let seconds = String(format: "%02d", (sec%60))
        let minutes = String(format: "%02d", sec/60)
        let txt = "\(minutes):\(seconds)"
        return txt
    }
}

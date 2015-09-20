//
//  TripInfo.swift
//  TripStuff2
//
//  Created by SHAWN on 9/17/15.
//  Copyright © 2015 SHAWN. All rights reserved.
//

import UIKit

struct Constant {
    static let StayOrMoveStatusColume = ["Stay","Move"]
    //if StayOrMoveStatusDetail == other,it should be noted
    static let StayOrMoveStatusDetail = [["Hotel","View"],["Plane","Train","Subway","Bus","Boat","Foot","Bike","Other"]]
    
}

class TripInfo{
    //if stay in one place, u can ignore placeTo
    var placeFrom: String?
    var placeTo: String = ""
    var timeBegin: NSDate?
    var timeEnd: NSDate?
    var status: String = "Foot"
    var statusImage: UIImage?
    var imageForRouteInMap: UIImage?
    var note: String = ""
    var price: Double = 0
    init(placeFrom: String, timeBegin: NSDate, timeEnd: NSDate)
    {
        self.placeFrom = placeFrom
        self.timeBegin = timeBegin
        self.timeEnd = timeEnd
    }
}

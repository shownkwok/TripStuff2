//
//  Waypoint.swift
//  TripStuff2
//
//  Created by SHAWN on 9/20/15.
//  Copyright © 2015 SHAWN. All rights reserved.
//

import UIKit
import MapKit
class Waypoint: NSObject, MKAnnotation{
    var title: String?
    var subtitle: String?
    var nation: String?
    var city: String?
    var info: String?
    var dateAndTime: NSDate?
    var latitude: CLLocationDegrees?
    var longitude: CLLocationDegrees?
    var coordinate: CLLocationCoordinate2D{
        return CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
    }
    init(title: String, latitude: CLLocationDegrees, longitude:CLLocationDegrees){
        self.title = title
        self.latitude = latitude
        self.longitude = longitude
    }
}

class EditableWaypoint: Waypoint {
    override var coordinate: CLLocationCoordinate2D{
        get {return super.coordinate}
        set {
            latitude = newValue.latitude
            longitude = newValue.longitude
            print("newLatidude is \(newValue.latitude)")
        }
    }
}

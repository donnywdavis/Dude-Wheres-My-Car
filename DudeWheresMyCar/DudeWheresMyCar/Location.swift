//
//  Location.swift
//  DudeWheresMyCar
//
//  Created by Donny Davis on 5/13/16.
//  Copyright © 2016 Donny Davis. All rights reserved.
//

import UIKit

class Location: NSObject {
    var latitude: Double?
    var longitude: Double?
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}

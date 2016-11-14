//
//  Model.swift
//  DummyBeaconApp
//
//  Created by Daniel Seijo Sánchez on 30/8/15.
//  Copyright © 2015 Daniel Seijo Sánchez. All rights reserved.
//

import Foundation

class Model {
    
    func meters2Point (_ meters: Double, withMaxMeters: Double, inRangeMin: Float, andMax: Float) -> Float {
        let totalPoints = ((Float(meters) * (andMax - inRangeMin)) / Float(withMaxMeters))
        return inRangeMin + totalPoints
    }
    
}

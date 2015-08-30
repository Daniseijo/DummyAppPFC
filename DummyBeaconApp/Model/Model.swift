//
//  Model.swift
//  DummyBeaconApp
//
//  Created by Daniel Seijo Sánchez on 30/8/15.
//  Copyright (c) 2015 Daniel Seijo Sánchez. All rights reserved.
//

import UIKit

class Model: NSObject {

    func meters2Point (meters: Double, withMaxMeters: Double, inRangeMin: CGFloat, andMax: CGFloat) -> CGFloat {
        let totalPoints = ((CGFloat(meters) * (andMax - inRangeMin)) / CGFloat(withMaxMeters));
        return inRangeMin + totalPoints;
    }

}
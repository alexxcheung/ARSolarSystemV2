//
//  Extension.swift
//  ARSolarSystem2
//
//  Created by Alex Cheung on 4/28/19.
//  Copyright © 2019 Alex Cheung. All rights reserved.
//

import Foundation

extension FloatingPoint {
    var degreesToRadians : Self {
        return self * .pi / 180
    }
    var radiansToDegrees : Self {
        return self * 180 / .pi
    }
}






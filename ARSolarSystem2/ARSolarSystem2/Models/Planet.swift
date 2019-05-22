//
//  Planet.swift
//  ARSolarSystem2
//
//  Created by Alex Cheung on 4/29/19.
//  Copyright © 2019 Alex Cheung. All rights reserved.
//

import Foundation
import SceneKit

//Name,rank,Radius(in km),Distance from Sun (in million km), time to go around the sun (in terms of earth day), description

struct Planet {
    var name: String
    var rank: Float
    var radius: Float
    var distanceFromSun: Float
    var timeToAround: Double
    var description: String
    
    init (name: String, rank: Float, radius: Float, distanceFromSun: Float, timeToAround: Double, description: String) {
        self.name = name
        self.rank = rank
        self.radius = radius
        self.distanceFromSun = distanceFromSun
        self.timeToAround = timeToAround
        self.description = description
    }
}

class Global {
    static let shared = Global()
    
    var planetData : [Planet] = []
    let sunNode = SCNNode()
}

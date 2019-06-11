//
//  Tracker.swift
//  ARSolarSystem2
//
//  Created by Alex Cheung on 5/16/19.
//  Copyright © 2019 Alex Cheung. All rights reserved.
//

import SceneKit

struct Tracker {
    var trackerNode: SCNNode?
    var isSurfaceFound: Bool = false
    var isSurfaceTracking: Bool = true
    var placingPosition: SCNVector3?
}

var tracker = Tracker()

//
//  SessionState.swift
//  ARSolarSystem2
//
//  Created by Alex Cheung on 5/16/19.
//  Copyright © 2019 Alex Cheung. All rights reserved.
//

import Foundation

//sessionState
enum SessionState {
    case surfaceTracking
    case universePlaced
    case planetSelected
    case funMode
    case gameOver
}

var sessionState: SessionState!

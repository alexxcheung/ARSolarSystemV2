//
//  setup3Dobject.swift
//  ARSolarSystem2
//
//  Created by Alex Cheung on 5/16/19.
//  Copyright © 2019 Alex Cheung. All rights reserved.
//

import Foundation
import SceneKit
import ARKit

func showPlanetName(planetName: String, planetPosition: SCNVector3, view: ARSCNView) {
    let text = SCNText(string: planetName, extrusionDepth: 0.1)
    text.font = UIFont(name: "Helvetica Neue", size: 1)
    text.flatness = 0.05
    text.firstMaterial?.diffuse.contents = UIColor.white
    
    let textNode = SCNNode(geometry: text)
    let fontSize = Float(0.04)
    textNode.scale = SCNVector3(fontSize, fontSize, fontSize)
    textNode.position = planetPosition
    textNode.name = "PlanetName"
    textNode.constraints = [SCNBillboardConstraint()] //always facing camera
    
    view.scene.rootNode.addChildNode(textNode)
}

func show3DMessage (message: String, view: ARSCNView) {
    removeNode(named: "3DMessage", view: view)
    
    let text = SCNText(string: message, extrusionDepth: 0.1)
    text.font = UIFont.systemFont(ofSize: 0.5)
    text.flatness = 0.06
    text.firstMaterial?.diffuse.contents = UIColor.white
    
    let textNode = SCNNode(geometry: text)
    
    let fontSize = Float(0.1)
    textNode.scale = SCNVector3(fontSize, fontSize, fontSize)
    textNode.position = SCNVector3(Global.shared.sunNode.position.x, Global.shared.sunNode.position.y + 0.3, Global.shared.sunNode.position.z)
    textNode.name = "3DMessage"
    textNode.constraints = [SCNBillboardConstraint()]
    
    view.scene.rootNode.addChildNode(textNode)
}

public func removeNode(named:String, view: ARSCNView){
    guard view.scene.rootNode.childNodes.isEmpty == false else {return}
    print(view.scene.rootNode.childNodes.count)
    
    view.scene.rootNode.enumerateChildNodes { (node, _) in
        if node.name == named {
            node.removeFromParentNode()
        }
    }
}

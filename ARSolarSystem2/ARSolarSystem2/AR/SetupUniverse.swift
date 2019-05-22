//
//  Universe.swift
//  WWDCplayground
//
//  Created by Alex Cheung on 3/16/19.
//  Copyright © 2019 Alex Cheung. All rights reserved.
//

import Foundation
import SceneKit
import ARKit

//setting up universe size
var universeWidth : CGFloat = 0.001
var universeHeight : CGFloat = 2.8 //lower than 3
var universeLength : CGFloat = 2.8

func createWall() -> SCNNode {
    
    let node = SCNNode()
    
    //Add Inner Wall
    let innerWall = SCNBox(width: universeWidth, height: universeHeight, length: universeLength, chamferRadius: 0)
    innerWall.firstMaterial?.diffuse.contents = UIImage(named: "Universe")
    let innerWallNode = SCNNode(geometry: innerWall)
    innerWallNode.renderingOrder = 750
    innerWallNode.opacity = 1
    innerWallNode.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
    innerWallNode.physicsBody?.isAffectedByGravity = false
    innerWallNode.physicsBody?.categoryBitMask = 1
    innerWallNode.physicsBody?.contactTestBitMask = 4
    innerWallNode.physicsBody?.collisionBitMask = 4
    innerWallNode.name = "Wall"
    
    node.addChildNode(innerWallNode)
    
    //Add Invisible OuterWall
    let outerWall = SCNBox(width: universeWidth, height: universeHeight, length: universeLength, chamferRadius: 0)
    outerWall.firstMaterial?.diffuse.contents = UIColor.white
    outerWall.firstMaterial?.transparency = 0.00000001
    
    let outerWallNode = SCNNode(geometry: outerWall)
    outerWallNode.renderingOrder = 250
    outerWallNode.position = SCNVector3.init(universeWidth, 0, 0)
    
    node.addChildNode(outerWallNode)
    
    return node
}

func addUniverseWall(trackerPosition: SCNVector3, view: ARSCNView) {
    
    let node = SCNNode()
    node.position = trackerPosition
    
    let leftWall = createWall()
    let rightWall = createWall()
    let topWall = createWall()
    let bottomWall = createWall()
    let backWall = createWall()
    let frontWall = createWall()
    
    leftWall.position = SCNVector3.init((-universeLength / 2) + universeWidth, 0, 0)
    leftWall.eulerAngles = SCNVector3.init(0, 180.0.degreesToRadians, 0)
    rightWall.position = SCNVector3.init((universeLength / 2) - universeWidth, 0, 0)
    topWall.position = SCNVector3.init(0, (universeHeight / 2) - universeWidth, 0)
    topWall.eulerAngles = SCNVector3.init(0, 0, 90.0.degreesToRadians)
    bottomWall.position = SCNVector3.init(0, (-universeHeight / 2) + universeWidth, 0)
    bottomWall.eulerAngles = SCNVector3.init(0, 0, -90.0.degreesToRadians)
    backWall.position = SCNVector3.init(0, 0, (-universeHeight / 2) + universeWidth)
    backWall.eulerAngles = SCNVector3.init(0, 90.0.degreesToRadians, 0)
    frontWall.position = SCNVector3.init(0,0, (universeHeight/2) + universeWidth)
    frontWall.eulerAngles = SCNVector3.init(0, -90.0.degreesToRadians, 0)
    
    node.addChildNode(leftWall)
    node.addChildNode(rightWall)
    node.addChildNode(topWall)
    node.addChildNode(bottomWall)
    node.addChildNode(backWall)
    node.addChildNode(frontWall)
    
    view.scene.rootNode.addChildNode(node)
}






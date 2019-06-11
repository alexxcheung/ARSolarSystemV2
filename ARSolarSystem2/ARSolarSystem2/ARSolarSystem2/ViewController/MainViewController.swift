//
//  ViewController.swift
//  ARSolarSystem2
//
//  Created by Alex Cheung on 4/28/19.
//  Copyright © 2019 Alex Cheung. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class MainViewController: UIViewController {

    @IBOutlet var sceneView: ARSCNView!
    
    var timer: Timer?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupSceneView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGestureRecognizer()
        
        addHelpButton(view: sceneView)
        addMessageBox(messageToPlayer: messageDict["InstructionPlaceUniverse"]!, view: sceneView)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    //MARK: - Setting up
    private func setupSceneView() {
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal]
        
        sceneView.delegate = self
        sceneView.session.delegate = self
        sceneView.scene.physicsWorld.contactDelegate = self
        
        sessionState = .surfaceTracking

        sceneView.session.run(config, options: [.resetTracking, .removeExistingAnchors])
    }
    
    private func setupGestureRecognizer() {
        //GestureRecognizer
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        
        let tripleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTripleTap))
        tripleTapGestureRecognizer.numberOfTapsRequired = 3
        tripleTapGestureRecognizer.numberOfTouchesRequired = 1
        tapGestureRecognizer.require(toFail: tripleTapGestureRecognizer)

        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longPressGestureRecognizer.minimumPressDuration = 0.3
        
        sceneView.addGestureRecognizer(tapGestureRecognizer)
        sceneView.addGestureRecognizer(tripleTapGestureRecognizer)
        sceneView.addGestureRecognizer(longPressGestureRecognizer)
        
        tapGestureRecognizer.delegate = self
        tripleTapGestureRecognizer.delegate = self
        longPressGestureRecognizer.delegate = self
    }
    
    
}

extension MainViewController: UIGestureRecognizerDelegate {
    
    //MARK: - GestureReocignizer
    @objc func handleTap(recognizer: UITapGestureRecognizer) {
        
        let tappedView = recognizer.view as! SCNView
        let touchLocation = recognizer.location(in: tappedView)
        let hitTest = tappedView.hitTest(touchLocation, options: nil)
        
        if sessionState == SessionState.surfaceTracking {
            
            guard tracker.isSurfaceFound else { return }
            
            setupInitialGalaxy()
            
            tracker.isSurfaceTracking = false
            sessionState = SessionState.universePlaced
            
        } else if sessionState == SessionState.universePlaced { //after placing the Universe
            
            guard !hitTest.isEmpty else {return}
            guard let hitResult = hitTest.first else {return}
                
            if planetName.contains(hitResult.node.name!) { //selecting the planet information
                
                sessionState = SessionState.planetSelected
                Global.shared.sunNode.isPaused = true
                
                selectPlanetForInformation(hitResult: hitResult)
            }
            
        } else if sessionState == SessionState.planetSelected { //deselect planet
            sessionState = SessionState.universePlaced
            Global.shared.sunNode.isPaused = false
            
            deselectPlanet()
   
        } else if sessionState == SessionState.funMode { //Get into the UFO
//            guard let ufoNode = getUfoNode(from: touchLocation) else { return }
//            currentUfoNode = ufoNode
//            addMessageBox(messageToPlayer: "You have got into the UFO\n-Go behind the UFO and Destroy the planets NOW!-", view: sceneView)
        }
    }
    
    @objc func handleTripleTap(recognizer: UITapGestureRecognizer){
        if sessionState == SessionState.universePlaced { //turning on fun mode
            sessionState = SessionState.funMode
            
            //reset value
            numberOfPlanetDestroy = 0
            timer?.invalidate()
            timer = nil
            
            addMessageBox(messageToPlayer: messageDict["FunModeOn"]! + "\n" + messageDict["InstructionToControlUFO"]!, view: sceneView)
            addUfo()
            
        } else if sessionState == SessionState.funMode || sessionState == SessionState.gameOver { //turning off fun mode
            sessionState = SessionState.universePlaced
            Global.shared.sunNode.isPaused = false
            
            resetScene()
            addMessageBox(messageToPlayer: messageDict["LearningModeOn"]! + "\n" + messageDict["InstructionOnLearningMode"]!, view: sceneView)
        }
    }
    
    @objc func handleLongPress(recognizer: UILongPressGestureRecognizer) {
        
        guard sessionState == SessionState.funMode else {return}
        
        if recognizer.state == .began {
            timer = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(controlUFO), userInfo: nil, repeats: true)
        } else if recognizer.state == .ended || recognizer.state == .cancelled {
            timer?.invalidate()
            timer = nil
        }
    }
}

extension MainViewController {
    
    func setupInitialGalaxy() {
        tracker.placingPosition = SCNVector3(tracker.trackerNode!.position.x, tracker.trackerNode!.position.y + 1, tracker.trackerNode!.position.z)
        tracker.trackerNode?.removeFromParentNode()
        
        addPlanetData()
//        addUniverseWall(trackerPosition: tracker.placingPosition!, view: sceneView)
        addPlanet(trackerPosition: tracker.placingPosition!, view: sceneView)
        addMessageBox(messageToPlayer: messageDict["LearningModeOn"]! + "\n" + messageDict["InstructionOnLearningMode"]!, view: sceneView)
    }
    
    func selectPlanetForInformation(hitResult: SCNHitTestResult) {
        //get the hitTest location
        let translation = hitResult.modelTransform
        var x = translation.m41
        var y = translation.m42
        let z = translation.m43
        var rank = 0
        
        for temp in 0...Global.shared.planetData.count - 1 {
            if Global.shared.planetData[temp].name == hitResult.node.name {
                rank = temp
                break
            }
        }
        
        switch hitResult.node.name {
            case "The Sun":
                x = x + 0.15
                y = y + 0.15
            case "Jupiter", "Saturn":
                x = x + 0.08
                y = y + 0.08
            case "Uranus", "Neptune":
                x = x + 0.02
                y = y + 0.02
            default:
                break
        }
        let planetPosition = SCNVector3(x,y,z)
        
        showPlanetName(planetName: hitResult.node.name!, planetPosition: planetPosition, view: sceneView)
        showPlanetDescription(planetDescription: Global.shared.planetData[rank].description, view: sceneView)
        addMessageBox(messageToPlayer: messageDict["InstructionReturn"]!, view: sceneView)
    }
    
    func deselectPlanet() {
        addMessageBox(messageToPlayer: messageDict["LearningModeOn"]! + "\n" + messageDict["InstructionOnLearningMode"]!, view: sceneView)
        removeNode(named: "PlanetName", view: sceneView)
        removeView(tag: 200, view: sceneView)
    }
    
    func showResult(title: String, message: String, numberOfPlanetDestroy: Any) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title,
                                          message: "\(message)\n\(numberOfPlanetDestroy) planets have been destroyed", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
                self.addMessageBox(messageToPlayer: messageDict["InstructionOffFunMode"]!, view: self.sceneView)}))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func resetScene() {
        for planet in planetName {
            removeNode(named: planet, view: sceneView)
        }
        removeNode(named: "3DMessage", view: sceneView)
        removeNode(named: "UFO", view: sceneView)
        removeNode(named: "Light", view: sceneView)
        removeNode(named: "The Sun", view: sceneView)
        removeNode(named: "HelperNode", view: sceneView)
        
        addPlanet(trackerPosition: tracker.placingPosition!, view: sceneView)
    }
}

extension MainViewController: SCNPhysicsContactDelegate {
    //MARK: - Game
    func addUfo() {
        guard let frame = sceneView.session.currentFrame else { return }
        let camMatrix = SCNMatrix4(frame.camera.transform)
        let cameraCurrentPosition = SCNVector3Make(camMatrix.m41, camMatrix.m42, camMatrix.m43)
        
        let ufoNode = SCNNode()
        ufoNode.geometry = SCNTorus(ringRadius: 0.03, pipeRadius: 0.01)
        ufoNode.geometry?.firstMaterial?.diffuse.contents = UIColor.themePink
        
        ufoNode.position = cameraCurrentPosition
        ufoNode.name = "UFO"
        ufoNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        ufoNode.physicsBody?.isAffectedByGravity = false
        ufoNode.physicsBody?.categoryBitMask = BodyType.ufo.rawValue
        ufoNode.physicsBody?.contactTestBitMask = BodyType.wall.rawValue
        ufoNode.physicsBody?.collisionBitMask = ufoNode.physicsBody!.contactTestBitMask
        ufoNode.physicsBody?.mass = 1
        ufoNode.physicsBody?.rollingFriction = 0
        ufoNode.physicsBody?.restitution = 1
        
        currentUfoNode = ufoNode
        sceneView.scene.rootNode.addChildNode(ufoNode)
    }
    

    func destroyNode(_ node: SCNNode) {
        node.removeFromParentNode()
        
        if numberOfPlanetDestroy == 8 {
            sessionState = SessionState.gameOver
            showResult(title: "You Win", message: "Congratulation!", numberOfPlanetDestroy: "All")
        }
    }
    
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        if contact.nodeA.name == "UFO" {
            collisionBetween(ufo: contact.nodeA, object: contact.nodeB)
        } else if contact.nodeB.name == "UFO" {
            collisionBetween(ufo: contact.nodeB, object: contact.nodeA)
        }
        
        //explosion effect
        if let explosion = SCNParticleSystem(named: "Explosion.scnp", inDirectory: nil) {
            let explosionNode = SCNNode()
            explosionNode.position = contact.nodeB.presentation.position
            explosionNode.addParticleSystem(explosion)
            sceneView.scene.rootNode.addChildNode(explosionNode)
        }
    }
    
    func collisionBetween(ufo: SCNNode, object: SCNNode) {
        let objectName = object.name
        
        if object.name == "Wall" {
            destroyNode(ufo)
            
            addMessageBox(messageToPlayer: "Game Over\nYou get Lost in the Universe", view: sceneView)
            show3DMessage(message: "Game Over", view: sceneView)
            
            sessionState = .gameOver
            showResult(title: "You Lose", message: "You get lost in the Universe.", numberOfPlanetDestroy: numberOfPlanetDestroy)
            
        } else if object.name == "The Sun" {
            destroyNode(ufo)
            
            addMessageBox(messageToPlayer: "Game Over\nYou have CRASHED into the Sun", view: sceneView)
            show3DMessage(message: "Game Over", view: sceneView)
            
            sessionState = .gameOver
            showResult(title: "You Lose", message: "You Crashed into the Sun.", numberOfPlanetDestroy: numberOfPlanetDestroy)
            
        } else {
            numberOfPlanetDestroy += 1
            destroyNode(object)
            
            addMessageBox(messageToPlayer: "You destroyed \(objectName!)!\nNumber of planets destroyed: \(numberOfPlanetDestroy)", view: sceneView)
            show3DMessage(message: "Planet Destroyed: \(numberOfPlanetDestroy)", view: sceneView)
        }
    }
    
    @objc func controlUFO() { //need to change
        guard let frame = sceneView.session.currentFrame else { return }
        
        //for x and y position
        let camMatrix = SCNMatrix4(frame.camera.transform)
        let cameraCurrentPosition = SCNVector3Make(camMatrix.m41, camMatrix.m42, camMatrix.m43)
        
        guard let physicsBodyNode = currentUfoNode else {return}
        
        //UFO movement
        let ufoMovementX = CGFloat((physicsBodyNode.position.x - cameraCurrentPosition.x) * 0.5)
        let ufoMovementY = CGFloat((physicsBodyNode.position.y - cameraCurrentPosition.y) * 0.5)
        let ufoMovementZ = CGFloat((physicsBodyNode.position.z - cameraCurrentPosition.z) * 0.5)
        let movement = SCNAction.moveBy(x: ufoMovementX, y: ufoMovementY, z: ufoMovementZ, duration: 1)
        movement.timingMode = .easeInEaseOut
        
        physicsBodyNode.runAction(movement)
    }
}
        

extension MainViewController: ARSCNViewDelegate, ARSessionDelegate {
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        
        //tracking surface
        DispatchQueue.main.async {
            guard tracker.isSurfaceTracking else { return }
            
            let hitTest = self.sceneView.hitTest(CGPoint(x: self.view.frame.midX, y: self.view.frame.midY), types: .featurePoint)
            guard let result = hitTest.first else { return }
            
            let translation = SCNMatrix4(result.worldTransform)
            let position = SCNVector3Make(translation.m41, translation.m42, translation.m43)
            
            if tracker.trackerNode == nil { //trackernode property
                let plane = SCNPlane(width: 0.5, height: 0.5)
                plane.firstMaterial?.diffuse.contents = UIImage(named: "tracker.png")
                plane.firstMaterial?.isDoubleSided = true
                tracker.trackerNode = SCNNode(geometry: plane)
                tracker.trackerNode?.eulerAngles.x = -.pi * 0.5
                tracker.trackerNode?.eulerAngles.y = .pi * 0.25
                
                self.sceneView.scene.rootNode.addChildNode(tracker.trackerNode!)
                
                //Session changed
                tracker.isSurfaceFound = true
            }
            tracker.trackerNode?.position = position
        }
    }
    
    //  MARK: - ARSessionObserver
    
    func session(_ session: ARSession,
                 didFailWithError error: Error) {
        print("Session Failed - probably due to lack of camera access")
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        print("Session interrupted")
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        print("Session resumed")
        sceneView.session.run(session.configuration!, options: [.resetTracking,.removeExistingAnchors])
    }
}



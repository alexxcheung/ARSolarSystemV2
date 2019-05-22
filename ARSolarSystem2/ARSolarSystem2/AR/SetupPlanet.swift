//
//  Planet.swift
//  WWDCplayground
//
//  Created by Alex Cheung on 3/16/19.
//  Copyright © 2019 Alex Cheung. All rights reserved.
//

import Foundation
import SceneKit
import ARKit

func addPlanetNode(planet: [Planet]) -> SCNNode  {
    
    let helperNode = SCNNode()
    helperNode.position = SCNVector3(0,0,0)
    helperNode.isHidden = false
    helperNode.name = "HelperNode"
    
    var previousRandomX: Float? = nil
    var previousRandomZ: Float? = nil
    
    for rank in 0...planet.count - 1 {
        if planet[rank].name == "The Sun" {
            Global.shared.sunNode.geometry = SCNSphere(radius: 0.2)
            Global.shared.sunNode.position = SCNVector3(0,0,0)
            Global.shared.sunNode.name = planet[rank].name
            
            Global.shared.sunNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "\(planet[rank].name).jpg")
            Global.shared.sunNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
            Global.shared.sunNode.physicsBody?.isAffectedByGravity = false
            Global.shared.sunNode.physicsBody?.categoryBitMask = 8
            Global.shared.sunNode.physicsBody?.contactTestBitMask = 4
            Global.shared.sunNode.physicsBody?.collisionBitMask = 4
            
            Global.shared.sunNode.addChildNode(helperNode)
            
        } else {
            let node = SCNNode()
            
            var planetPositionX: Float
            var planetPositionZ: Float
            var planetPositionY: Float
            var scale: Float
            
            var isPreviousEqual: Bool
            
            switch planet[rank].name {
            case "Jupiter", "Saturn","Uranus", "Neptune":
                scale = 0.1
            default:
                scale = 0.05
            }
            
            var randomX: Float
            var randomZ: Float
            
            repeat {
                isPreviousEqual = false
                
                randomX = Float(Int.random(in: -1 ... 1))
                randomZ = Float(Int.random(in: -1 ... 1))
                
                planetPositionX = (0.2 + scale * planet[rank].rank) * randomX
                planetPositionZ = (0.2 + scale * planet[rank].rank) * randomZ
                
                if (previousRandomX == randomX) && (previousRandomZ == randomZ) {
                    isPreviousEqual = true
                }
            } while (planetPositionX == 0 && planetPositionZ == 0) || (isPreviousEqual == true)
            
            previousRandomX = randomX
            previousRandomZ = randomZ
            
            switch planet[rank].name {
            case "Jupiter", "Saturn", "Uranus", "Neptune":
                planetPositionY = (planet[rank].rank - 4) * 0.1
            default:
                planetPositionY = 0
            }
            
            node.geometry = SCNSphere (radius: CGFloat(planet[rank].radius/800000)) //change radius
            node.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "\(planet[rank].name).jpg")
            node.position = SCNVector3(planetPositionX, planetPositionY, planetPositionZ)
            
            node.name = planet[rank].name
            node.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
            node.physicsBody?.isAffectedByGravity = false
            node.physicsBody?.categoryBitMask = 2
            node.physicsBody?.contactTestBitMask = 4
            node.physicsBody?.collisionBitMask = 4
            
            if planet[rank].name == "Saturn" {
                if let ringScene = SCNScene(named: "ring.scn") {
                    let ringNode = ringScene.rootNode.childNode(withName: "Ring", recursively: true)
                    node.addChildNode(ringNode!)
                }
            }
            
            //Self Rotation
            let rotate = SCNAction.rotateBy(x: 0, y: CGFloat(360.degreesToRadians), z: 0, duration: 10)
            let rotateForever = SCNAction.repeatForever(rotate)
            node.runAction(rotateForever)
            
            //Rotate around the sun
            let rotation = SCNAction.rotateBy(x: 0, y: 1, z: 0, duration: planet[rank].timeToAround/8) //change duration
            let keepRotating = SCNAction.repeatForever(rotation)
            helperNode.runAction(keepRotating)
            
            helperNode.addChildNode(node)
        }
    }
    return Global.shared.sunNode
}

func addPlanet(trackerPosition: SCNVector3, view: ARSCNView) {
    let planetNode = addPlanetNode(planet: Global.shared.planetData)
    planetNode.position = SCNVector3(x: trackerPosition.x, y: trackerPosition.y, z: trackerPosition.z)
    
    view.scene.rootNode.addChildNode(planetNode)
}

func addPlanetData(){
    //Data of the planets
    let dataSun = Planet(name: "The Sun", rank: 0, radius: 695510, distanceFromSun: 0, timeToAround: 0,
                         description: "The Sun is the Solar System's star and by far its most massive component. Its large mass (332,900 Earth masses), which comprises 99.86% of all the mass in the Solar System, produces temperatures and densities in its core high enough to sustain nuclear fusion of hydrogen into helium, making it a main-sequence star. This releases an enormous amount of energy, mostly radiated into space as electromagnetic radiation peaking in visible light.\n\nThe Sun is a G2-type main-sequence star. Hotter main-sequence stars are more luminous. The Sun's temperature is intermediate between that of the hottest stars and that of the coolest stars. Stars brighter and hotter than the Sun are rare, whereas substantially dimmer and cooler stars, known as red dwarfs, make up 85% of the stars in the Milky Way.\n\nThe Sun is a population I star; it has a higher abundance of elements heavier than hydrogen and helium (metals in astronomic al parlance) than the older population II stars. Elements heavier than hydrogen and helium were formed in the cores of ancient and exploding stars, so the first generation of stars had to die before the Universe could be enriched with these atoms. The oldest stars contain few metals, whereas stars born later have more. This high metallicity is thought to have been crucial to the Sun's development of a planetary system because the planets form from the accretion of metals")
    let dataMercury = Planet(name: "Mercury", rank: 1, radius: 2440, distanceFromSun: 57.9, timeToAround: 87.96,
                             description: "Mercury (0.4 AU from the Sun) is the closest planet to the Sun and the smallest planet in the Solar System (0.055 M⊕). Mercury has no natural satellites; besides impact craters, its only known geological features are lobed ridges or rupes that were probably produced by a period of contraction early in its history. Mercury's very tenuous atmosphere consists of atoms blasted off its surface by the solar wind. Its relatively large iron core and thin mantle have not yet been adequately explained. Hypotheses include that its outer layers were stripped off by a giant impact; or, that it was prevented from fully accreting by the young Sun's energy.")
    let dataVenus = Planet(name: "Venus", rank: 2, radius: 6052, distanceFromSun: 108.2, timeToAround: 224.68,
                           description: "Venus (0.7 AU from the Sun) is close in size to Earth (0.815 M⊕) and, like Earth, has a thick silicate mantle around an iron core, a substantial atmosphere, and evidence of internal geological activity. It is much drier than Earth, and its atmosphere is ninety times as dense. Venus has no natural satellites. It is the hottest planet, with surface temperatures over 400 °C (752 °F), most likely due to the amount of greenhouse gases in the atmosphere. No definitive evidence of current geological activity has been detected on Venus, but it has no magnetic field that would prevent depletion of its substantial atmosphere, which suggests that its atmosphere is being replenished by volcanic eruptions.")
    let dataEarth = Planet(name: "Earth", rank: 3, radius: 6378, distanceFromSun: 149.6, timeToAround: 365.26,
                           description: "Earth (1 AU from the Sun) is the largest and densest of the inner planets, the only one known to have current geological activity, and the only place where life is known to exist. Its liquid hydrosphere is unique among the terrestrial planets, and it is the only planet where plate tectonics has been observed. Earth's atmosphere is radically different from those of the other planets, having been altered by the presence of life to contain 21% free oxygen. It has one natural satellite, the Moon, the only large satellite of a terrestrial planet in the Solar System.")
    let dataMars = Planet(name: "Mars", rank: 4, radius: 3396, distanceFromSun: 227.9, timeToAround: 686.98,
                          description: "Mars (1.5 AU from the Sun) is smaller than Earth and Venus (0.107 M⊕). It has an atmosphere of mostly carbon dioxide with a surface pressure of 6.1 millibars (roughly 0.6% of that of Earth). Its surface, peppered with vast volcanoes, such as Olympus Mons, and rift valleys, such as Valles Marineris, shows geological activity that may have persisted until as recently as 2 million years ago. Its red colour comes from iron oxide (rust) in its soil. Mars has two tiny natural satellites (Deimos and Phobos) thought to be either captured asteroids, or ejected debris from a massive impact early in Mars's history.")
    let dataJupiter = Planet(name: "Jupiter", rank: 5, radius: 71492, distanceFromSun: 778.3, timeToAround: 11.862*365.26,
                             description: "Jupiter (5.2 AU), at 318 M⊕, is 2.5 times the mass of all the other planets put together. It is composed largely of hydrogen and helium. Jupiter's strong internal heat creates semi-permanent features in its atmosphere, such as cloud bands and the Great Red Spot. Jupiter has 79 known satellites. The four largest, Ganymede, Callisto, Io, and Europa, show similarities to the terrestrial planets, such as volcanism and internal heating. Ganymede, the largest satellite in the Solar System, is larger than Mercury.")
    let dataSaturn = Planet(name: "Saturn", rank: 6, radius: 60268, distanceFromSun: 1427.0, timeToAround: 29.456*365.26,
                            description: "Saturn (9.5 AU), distinguished by its extensive ring system, has several similarities to Jupiter, such as its atmospheric composition and magnetosphere. Although Saturn has 60% of Jupiter's volume, it is less than a third as massive, at 95 M⊕. Saturn is the only planet of the Solar System that is less dense than water. The rings of Saturn are made up of small ice and rock particles. Saturn has 62 confirmed satellites composed largely of ice. Two of these, Titan and Enceladus, show signs of geological activity. Titan, the second-largest moon in the Solar System, is larger than Mercury and the only satellite in the Solar System with a substantial atmosphere.")
    let dataUranus = Planet(name: "Uranus", rank: 7, radius: 25559, distanceFromSun: 2871.0, timeToAround: 84.07*365.26,
                            description: "Uranus (19.2 AU), at 14 M⊕, is the lightest of the outer planets. Uniquely among the planets, it orbits the Sun on its side; its axial tilt is over ninety degrees to the ecliptic. It has a much colder core than the other giant planets and radiates very little heat into space. Uranus has 27 known satellites, the largest ones being Titania, Oberon, Umbriel, Ariel, and Miranda.")
    let dataNeptune = Planet(name: "Neptune", rank: 8, radius: 24764, distanceFromSun: 4497.1, timeToAround: 164.81*365.26,
                             description: "Neptune (30.1 AU), though slightly smaller than Uranus, is more massive (17 M⊕) and hence more dense. It radiates more internal heat, but not as much as Jupiter or Saturn. Neptune has 14 known satellites. The largest, Triton, is geologically active, with geysers of liquid nitrogen. Triton is the only large satellite with a retrograde orbit. Neptune is accompanied in its orbit by several minor planets, termed Neptune trojans, that are in 1:1 resonance with it.")
    
    Global.shared.planetData.append(dataSun)
    Global.shared.planetData.append(dataMercury)
    Global.shared.planetData.append(dataVenus)
    Global.shared.planetData.append(dataEarth)
    Global.shared.planetData.append(dataMars)
    Global.shared.planetData.append(dataJupiter)
    Global.shared.planetData.append(dataSaturn)
    Global.shared.planetData.append(dataUranus)
    Global.shared.planetData.append(dataNeptune)
}




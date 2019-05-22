//
//  UIDisplay.swift
//  ARSolarSystem2
//
//  Created by Alex Cheung on 4/28/19.
//  Copyright © 2019 Alex Cheung. All rights reserved.
//

import Foundation
import UIKit
import ARKit
import SceneKit

extension MainViewController {
    
    func addHelpButton(view: ARSCNView) {
        DispatchQueue.main.async {
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            button.alpha = 0.8
            button.backgroundColor = UIColor.darkGray
            button.layer.borderWidth = 0.5
            button.layer.borderColor = UIColor.themePink.cgColor
            button.layer.cornerRadius = 4
            button.layer.masksToBounds = true
            
            button.addTarget(self, action: #selector(self.helpMenuButton_clicked), for: .touchUpInside)
            
            view.addSubview(button)
            
            //constraint
            button.translatesAutoresizingMaskIntoConstraints = false
            button.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
            button.widthAnchor.constraint(equalToConstant: 40).isActive = true
            button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        }
        
    }
    
    @objc func helpMenuButton_clicked() {
        setupPopupHelpMenu()
    
    }
        

    func addMessageBox(messageToPlayer: String, view: ARSCNView) {
        
        removeView(tag: 100, view: view)
        
        DispatchQueue.main.async {
            let messageBoxView = PaddingLabel(frame: .zero)
            
            messageBoxView.backgroundColor = UIColor.lightGray
            messageBoxView.alpha = 0.8
            messageBoxView.textColor = UIColor.white
            messageBoxView.font = UIFont.systemFont(ofSize: 16.0)
            messageBoxView.textAlignment = .left
            messageBoxView.text = messageToPlayer
            
            messageBoxView.sizeToFit()
            messageBoxView.layer.cornerRadius = 4
            messageBoxView.layer.masksToBounds = true
            messageBoxView.layer.borderWidth = 0.5
            messageBoxView.layer.borderColor = UIColor.themePink.cgColor
            
            messageBoxView.numberOfLines = 10
            messageBoxView.lineBreakMode = .byWordWrapping
     
            messageBoxView.tag = 100
            
            view.addSubview(messageBoxView)
            
            //Constraints
            messageBoxView.translatesAutoresizingMaskIntoConstraints = false //debugging error
            messageBoxView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
            messageBoxView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
            messageBoxView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: (-20-40-20)).isActive = true
            
            
            //        Timer.scheduledTimer(timeInterval: 3.0, target: view, selector: #selector(messageBoxView.removeFromSuperview()), userInfo: nil, repeats: false)
        }
    }
    

    func showPlanetDescription(planetDescription: String, view: ARSCNView) { //UItextView
        DispatchQueue.main.async {
            let textView = UITextView(frame: .zero)
            textView.center = view.center
            
            textView.backgroundColor = UIColor.darkGray
            textView.layer.cornerRadius = 4
            textView.layer.masksToBounds = true
            textView.layer.borderWidth = 0.5
            textView.layer.borderColor = UIColor.themePink.cgColor
            
            textView.setContentOffset(CGPoint.zero, animated: false)
            textView.contentInset = UIEdgeInsets(top: 5, left: 7, bottom: 5, right: 7)
            textView.alpha = 0.9
            textView.textColor = UIColor.white
            textView.font = UIFont(name: "Helvetica Neue", size: 16)
            textView.textAlignment = .left
            textView.text = planetDescription
            
            textView.isSelectable = false
            textView.isEditable = false
            textView.tag = 200
            
            view.addSubview(textView)
            
            //Constraints
            textView.translatesAutoresizingMaskIntoConstraints = false
            textView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6).isActive = true
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
            textView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            textView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        }
    }
    
    public func removeView(tag: Int, view: ARSCNView) {
        DispatchQueue.main.async {
            if let viewRemove = view.viewWithTag(tag) {
                viewRemove.removeFromSuperview()
            }
        }
    }
    
    func setupPopupHelpMenu() {
        guard let popupViewController = storyboard?.instantiateViewController(withIdentifier: "PopHelpMenuViewController") else {return}
        guard let popupView = popupViewController.view else {return}
        
        popupViewController.modalTransitionStyle   = .crossDissolve
        popupViewController.modalPresentationStyle = .overCurrentContext
        
        popupView.backgroundColor = .init(white: 1, alpha: 0.5)
        
        
        self.present(popupViewController, animated: true, completion: nil)
    }
    
    
    
    
}










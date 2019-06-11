//
//  PopHelpViewController.swift
//  ARSolarSystem2
//
//  Created by Alex Cheung on 5/17/19.
//  Copyright © 2019 Alex Cheung. All rights reserved.
//

import UIKit

class PopHelpMenuViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUIView()
    }
    
    func setupUIView() {
        let backgroundView = UIView()
        
        backgroundView.backgroundColor = .white
        backgroundView.layer.borderColor = UIColor.themePink.cgColor
        backgroundView.layer.borderWidth = 0.1
        
        view.addSubview(backgroundView)
        
        
        //constraint
        backgroundView.translatesAutoresizingMaskIntoConstraints = false

        backgroundView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6).isActive = true
        backgroundView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        backgroundView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        backgroundView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
    }
   

}

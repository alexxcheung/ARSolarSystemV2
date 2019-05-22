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
        // Do any additional setup after loading the view.
    }
    
    func setupUIView() {
        let backgroundView = UIView()
        
        backgroundView.backgroundColor = .red
        
        view.addSubview(backgroundView)
        
        
        //constraint
        backgroundView.translatesAutoresizingMaskIntoConstraints = false

        backgroundView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6).isActive = true
        backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        backgroundView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        backgroundView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
    }
   

}

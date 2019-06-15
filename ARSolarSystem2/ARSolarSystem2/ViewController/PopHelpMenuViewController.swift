//
//  PopHelpViewController.swift
//  ARSolarSystem2
//
//  Created by Alex Cheung on 5/17/19.
//  Copyright © 2019 Alex Cheung. All rights reserved.
//

import UIKit

class PopHelpMenuViewController: UIViewController {

    let backgroundView = UIView()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUIView()
        
        
    }
    
    func setupUIView() {
        
        backgroundView.backgroundColor = nil
        
        view.addSubview(backgroundView)
        
        //constraint
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5).isActive = true
        backgroundView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7).isActive = true
        backgroundView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        backgroundView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        let resetButton = UIButton()
        resetButton.formatSettingButton()
        resetButton.setTitle("Reset", for: .normal)
        resetButton.addTarget(self, action: #selector(handleResetButton), for: .touchUpInside)
        
        let hintButton = UIButton()
        hintButton.formatSettingButton()
        hintButton.setTitle("Hints", for: .normal)
        hintButton.addTarget(self, action: #selector(handleHintButton), for: .touchUpInside)
        
        let cancelButton = UIButton()
        cancelButton.formatSettingButton()
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.addTarget(self, action: #selector(handleCancelButton), for: .touchUpInside)
        
        let myStackView = UIStackView(frame: CGRect(x: 0, y: 0, width: 320, height: 300))
        myStackView.axis = .vertical
        myStackView.distribution = .equalSpacing
        myStackView.alignment = .center
        myStackView.spacing = 30.0
        
        myStackView.addArrangedSubview(resetButton)
        myStackView.addArrangedSubview(hintButton)
        myStackView.addArrangedSubview(cancelButton)
        
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        resetButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        resetButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        hintButton.translatesAutoresizingMaskIntoConstraints = false
        hintButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        hintButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        backgroundView.addSubview(myStackView)
        
        //set constraint on stackView to bottomView
        myStackView.translatesAutoresizingMaskIntoConstraints = false
        myStackView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor).isActive = true
        myStackView.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor).isActive = true
    }
    
    @objc func handleResetButton() {
        //print ResetButton Reset
    }
    
    
    
    @objc func handleHintButton() {
        
    }
    
    @objc func handleCancelButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
}

//
//  UIButton.swift
//  ARSolarSystem2
//
//  Created by Alex Cheung on 6/15/19.
//  Copyright © 2019 Alex Cheung. All rights reserved.
//

import UIKit

extension UIButton {
    
    func formatSettingButton() {
        let button = self // changes made here
        
        button.backgroundColor = .black
        button.tintColor = .white
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.themePink.cgColor
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.titleEdgeInsets = UIEdgeInsets(top: -10,left: -10,bottom: -10,right: -10)
        button.contentEdgeInsets = UIEdgeInsets(top: 10,left: 50,bottom: 10,right: 50)
    }
}

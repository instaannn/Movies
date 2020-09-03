//
//  UIView.swift
//  Movies
//
//  Created by Анна Сычева on 02.09.2020.
//  Copyright © 2020 Анна Сычева. All rights reserved.
//

import UIKit

//MARK: - UIView

extension UIView {
    
    // MARK: - Public methods
    
    func setGradient(colorOne: UIColor, colorTwo: UIColor) {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor]
        gradientLayer.locations = [Constants.locationsZero, Constants.locationsOne]
        gradientLayer.startPoint = CGPoint(x: Constants.doubleOne, y: Constants.doubleOne)
        gradientLayer.endPoint = CGPoint(x: Constants.doubleZero, y: Constants.doubleZero)
        
        layer.insertSublayer(gradientLayer, at: Constants.insertSublayer)
    }
    
    //MARK: - Constants

    enum Constants {
        static let doubleZero: Double = 0.0
        static let doubleOne: Double = 1.0
        static let insertSublayer: UInt32 = 0
        static let locationsZero: NSNumber = 0.0
        static let locationsOne: NSNumber = 1.0
    }
    
}

//
//  ExtensionCALayer.swift
//  Randomie
//
//  Created by Nguyen NGO on 20/06/2022.
//

import UIKit

extension CALayer: Animate {
    
    func animateRandomLayer(after: CFTimeInterval = 0.0, duration: CFTimeInterval, repeatDuration: CFTimeInterval) {
        let animation = CABasicAnimation(keyPath: "opacity")
        
        animation.fromValue = 1.0
        animation.toValue = 0.1
        animation.duration = duration
        animation.beginTime = CACurrentMediaTime() + after
        animation.fillMode = .removed
        animation.repeatDuration = repeatDuration
        
        self.add(animation, forKey: nil)
    }
    
}

protocol Animate {
    
    func animateRandomLayer(after: CFTimeInterval, duration: CFTimeInterval, repeatDuration: CFTimeInterval)
    
}

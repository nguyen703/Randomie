//
//  RandomButton.swift
//  Randomie
//
//  Created by Nguyen NGO on 31/05/2022.
//

import UIKit


extension UIButton: CustomProperties {
    
    func customizeRandomButton() {
        self.layer.cornerRadius = 6
        self.layer.borderColor = UIColor.white.cgColor
        self.setTitle("Randomize 😈", for: .normal)
        self.setTitleColor(UIColor.black, for: .normal)
        self.backgroundColor = UIColor.white
        self.layer.opacity = 0.8
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = K.Button.RandomButton.opacity
        self.layer.cornerRadius = K.Button.RandomButton.cornerRadius
    }
    
    func addTouchedEffect() {
        self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        
        UIView.animate(withDuration: 1.5,
                       delay: 0.1,
                       usingSpringWithDamping: CGFloat(0.20),
                       initialSpringVelocity: CGFloat(5.0),
                       options: UIView.AnimationOptions.allowUserInteraction,
                       animations: { self.transform = CGAffineTransform.identity },
                       completion: { Void in()  }
        )
    }
    
    
}

protocol CustomProperties {
    
    func customizeRandomButton()
    
    func addTouchedEffect()
    
}

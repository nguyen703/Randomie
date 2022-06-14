//
//  FloatyExtension.swift
//  Randomie
//
//  Created by Nguyen NGO on 09/06/2022.
//

import UIKit
import Floaty

//MARK: - Floaty Extension
extension Floaty: CustomFloaty {
    
    func customizeFloaty(buttonColor: UIColor = K.Button.FloatyButton.defaultButtonColor,
                         plusColor: UIColor = K.Button.FloatyButton.defaultIconTintColor) {
        
        self.openAnimationType = .slideUp
        self.sticky = true // sticking to parent
        self.buttonColor = buttonColor
        self.plusColor = plusColor
        
    }
    
}

//MARK: - FloatyItem Extension
extension FloatyItem: CustomItem {
    
    func customizeItem(title: String, icon: UIImage,
                       buttonColor: UIColor = K.Button.FloatyButton.defaultButtonColor,
                       iconTintColor: UIColor = K.Button.FloatyButton.defaultIconTintColor) {
        
        self.title = title
        self.icon = icon
        self.titleLabel.font = UIFont.systemFont(ofSize: K.Button.FloatyButton.titleLabelFont)
        self.imageOffset = CGPoint(x: -self.frame.width/8, y: 0)
        self.imageSize = CGSize(width: self.size * K.Button.FloatyButton.itemImageSizeScale,
                                height: self.size * K.Button.FloatyButton.itemImageSizeScale)
        self.buttonColor = buttonColor
        self.iconTintColor = iconTintColor
        
    }
    
}

//MARK: - Floaty Protocol
protocol CustomFloaty {
    
    func customizeFloaty(buttonColor: UIColor, plusColor: UIColor)
    
}

//MARK: - FloatyItem Protocol
protocol CustomItem {
    
    func customizeItem(title: String, icon: UIImage, buttonColor: UIColor, iconTintColor: UIColor)
    
}

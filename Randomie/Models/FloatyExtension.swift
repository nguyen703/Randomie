//
//  FloatyExtension.swift
//  Randomie
//
//  Created by Nguyen NGO on 09/06/2022.
//

import UIKit
import Floaty

extension FloatyItem: CustomItem {
    
    func customizeItem(title: String, icon: UIImage, buttonColor: UIColor = UIColor.systemTeal, iconTintColor: UIColor = UIColor.white) {
        
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


protocol CustomItem {
    
    func customizeItem(title: String, icon: UIImage, buttonColor: UIColor, iconTintColor: UIColor)
    
}

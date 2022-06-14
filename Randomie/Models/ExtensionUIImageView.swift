//
//  ExtensionUIImageView.swift
//  Randomie
//
//  Created by Nguyen NGO on 14/06/2022.
//

import UIKit

extension UIImageView {
    
    func customizeImageViewShadow() {
//        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = K.Button.RandomButton.opacity
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.clipsToBounds = false
    }
    
}

//
//  ExtensionUITableViewCell.swift
//  Randomie
//
//  Created by Nguyen NGO on 20/06/2022.
//

import UIKit

extension UITableViewCell: CustomCell {
    
    func configCellColor(cellTitle: String, cellImage: UIImage, textColor: UIColor = K.Palette.activeTextColor) {
        
        var content = self.defaultContentConfiguration()
        content.text = cellTitle
        content.image = cellImage
        content.textProperties.color = textColor
        content.imageProperties.tintColor = textColor
        self.contentConfiguration = content
        self.backgroundColor = .clear
        
    }
    
}

protocol CustomCell {
    
    func configCellColor(cellTitle: String,
                            cellImage: UIImage,
                            textColor: UIColor)
    
}

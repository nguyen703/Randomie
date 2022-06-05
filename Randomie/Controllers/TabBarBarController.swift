//
//  TabBarBarController.swift
//  Randomie
//
//  Created by Nguyen NGO on 01/06/2022.
//

import UIKit
import ChameleonFramework

class TabBarBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create gradient color based on Chameleon
        let gradientColor = GradientColor(.topToBottom, frame: UIScreen.main.bounds, colors: Array(arrayLiteral: K.Palette.firstColor, K.Palette.secondColor, K.Palette.thirdColor))
        
        // Chameleon helps create contrast color for text
        let contrastTextColor = ContrastColorOf(gradientColor, returnFlat: true)
        
        let appearance = UITabBarAppearance()
        
        // Configure Icon and Text color based on its states
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: contrastTextColor]
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.gray]
        appearance.stackedLayoutAppearance.selected.iconColor = contrastTextColor
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor.gray
        tabBar.standardAppearance = appearance
    }

}

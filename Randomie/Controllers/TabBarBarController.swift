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
        
        let appearance = UITabBarAppearance()
        
        // Configure Icon and Text color based on its states
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: K.Palette.activeTextColor]
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.gray]
        appearance.stackedLayoutAppearance.selected.iconColor = K.Palette.activeTextColor
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor.gray
        tabBar.standardAppearance = appearance
    }

}

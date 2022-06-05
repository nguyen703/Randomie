//
//  SettingsViewController.swift
//  Randomie
//
//  Created by Nguyen NGO on 01/06/2022.
//

import UIKit
import ChameleonFramework

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let navBar = navigationController?.navigationBar else { return }
        
        let gradientColor = GradientColor(.topToBottom, frame: UIScreen.main.bounds, colors: Array(arrayLiteral: K.Palette.firstColor, K.Palette.secondColor, K.Palette.thirdColor))
        let contrastTextColor = ContrastColorOf(gradientColor, returnFlat: true)
        
        navBar.tintColor = contrastTextColor
        
        navBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: contrastTextColor]
        view.backgroundColor = gradientColor
    }

}

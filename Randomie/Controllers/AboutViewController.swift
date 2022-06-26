//
//  AboutViewController.swift
//  Randomie
//
//  Created by QMac Store on 26/06/2022.
//

import UIKit
import ChameleonFramework

class AboutViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
    
    func setup() {
        let gradientColor = GradientColor(.leftToRight, frame: UIScreen.main.bounds, colors: Array(arrayLiteral: K.Palette.firstColor, K.Palette.secondColor, K.Palette.thirdColor))

        view.backgroundColor = gradientColor
    }
    

}

//
//  AboutViewController.swift
//  Randomie
//
//  Created by QMac Store on 26/06/2022.
//

import UIKit
import ChameleonFramework

class AboutViewController: UIViewController {

    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var text: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        setupText()
    }
    
    func setup() {
        let gradientColor = GradientColor(.leftToRight, frame: UIScreen.main.bounds, colors: Array(arrayLiteral: K.Palette.firstColor, K.Palette.secondColor, K.Palette.thirdColor))
        navBar.backgroundColor = .clear
        navBar.setBackgroundImage(UIImage(), for: .default)
        navBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: K.Palette.activeTextColor]
        view.backgroundColor = gradientColor
    }
    
    func setupText() {
        text.text = "I am a poor developer who develops non-sense apps..."
        text.textAlignment = .left
        text.textColor = K.Palette.activeTextColor
    }
    
}

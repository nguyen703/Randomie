//
//  EmojiViewController.swift
//  Randomie
//
//  Created by Nguyen NGO on 16/06/2022.
//

import UIKit
import ChameleonFramework

class EmojiViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: K.CollectionView.identifierEmoji)

        setup()
    }
    
    func setup() {
        label.textColor = K.Palette.activeTextColor
        let gradientColor = GradientColor(.leftToRight, frame: UIScreen.main.bounds, colors: Array(arrayLiteral: K.Palette.firstColor, K.Palette.secondColor, K.Palette.thirdColor))

        view.backgroundColor = gradientColor
    }
    
}

extension EmojiViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return EmojiData.emojiList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.CollectionView.identifierEmoji, for: indexPath)
        
        let emoji = Emoji(name: EmojiData.emojiList[indexPath.row])
        
        if emoji.selected {
            cell.backgroundColor = UIColor(white: 0.8, alpha: 0.7)
        } else {
            cell.backgroundColor = .clear
        }
        
        var config = UIListContentConfiguration.cell()
        config.text = emoji.name
        config.textProperties.font = UIFont.systemFont(ofSize: 30)
        
        cell.contentConfiguration = config
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        dismiss(animated: true) {
            UDManager.shared.defaults.setValue(EmojiData.emojiList[indexPath.row], forKey: K.UDManager.emojiKey)
        }
        
    }
    
    
}

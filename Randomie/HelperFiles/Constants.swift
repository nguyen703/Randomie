//
//  Constants.swift
//  Randomie
//
//  Created by Nguyen NGO on 25/05/2022.
//

import CoreGraphics
import UIKit
import ChameleonFramework

struct K {
    struct Layer {
        static let layerShadowColor: CGColor = CGColor(srgbRed: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        static let layerShadowRadius: CGFloat = 3.0
        static let layerShadowOpacity: Float = 0.3
        static let layerEmoji = "\u{1F383}" // 🎃
    }
    
    struct Animation {
        static let animRepeatDuration: CFTimeInterval = 4.0
        static var animDuration: CFTimeInterval {
            return animRepeatDuration / 5
        }
        static var animFindWinnerAfter: CFTimeInterval {
            return animRepeatDuration + 0.25
        }
        static let animFindWinnerRepeatDuration: CFTimeInterval = 2.5
        static var animFindWinnerDuration: CFTimeInterval {
            return animFindWinnerRepeatDuration / 5
        }
    }
    
    struct Palette {
        static let topLineColor: CGColor = CGColor(srgbRed: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        static let firstColor = UIColor(hexString: "caefd7")!
        static let secondColor = UIColor(hexString: "f5bfd7")!
        static let thirdColor = UIColor(hexString: "abc9e9")!
        static let activeTextColor = UIColor(hexString: "354259")!
    }
    
    struct Button {
        
        struct RandomButton {
            static let opacity: Float = 0.8
            static let cornerRadius: CGFloat = 6.0
            static let width: CGFloat = 200
            static let height: CGFloat = 50
        }
        
        struct FloatyButton {
            static let itemImageSizeScale = 0.45
            static let titleLabelFont: CGFloat = 16
            static let defaultButtonColor: UIColor = .systemTeal
            static let defaultIconTintColor: UIColor = .white
            static let buttonScaleVsScreen: CGFloat = 0.15
        }
        
    }
    
    struct Icon {
        static let mainScreen: String = "person-at"
        static let settingsScreen: String = "circle-cross-left"
    }
    
    struct TabBar {
        static let height: CGFloat = 67.0
    }
    
    struct TableView {
        static let identifierSettings: String = "Cell"
        static let segueChangeEmoji: String = "goToEmojiPicker"
        static let segueAboutUs: String = "goToAboutUs"
        static let sectionHeight: CGFloat = 55.0
        static let sectionFontSize: CGFloat = 22.0
    }
    
    struct CollectionView {
        static let identifierEmoji: String = "EmojiCell"
    }
    
    struct UDManager {
        static let emojiKey: String = "selectedKey"
    }
    
}

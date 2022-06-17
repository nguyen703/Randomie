//
//  Emoji.swift
//  Randomie
//
//  Created by Nguyen NGO on 17/06/2022.
//

import Foundation

struct Emoji {
    
    var name: String
    
    var selected: Bool {
        
        get {
            return UDManager.shared.defaults.object(forKey: K.UDManager.emojiKey) as? String == name
        }
        
    }
    
}

//
//  UserDefaultsManager.swift
//  Randomie
//
//  Created by Nguyen NGO on 17/06/2022.
//

import Foundation

class UDManager {
    
    static let shared = UDManager()
    
    let defaults = UserDefaults(suiteName: "com.hnguyenngo.Randomie.emoji")!
    
}

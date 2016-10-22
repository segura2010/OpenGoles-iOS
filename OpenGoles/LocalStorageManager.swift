//
//  LocalStorageManager.swift
//  OpenGoles
//
//  Created by Alberto on 22/10/16.
//  Copyright © 2016 Alberto. All rights reserved.
//

import Foundation

class LocalStorageManager {
    static let sharedInstance = LocalStorageManager()
    
    let DEFAULTS_NAME = "group.opengoles"
    
    
    
    func getLeague() -> Int
    {
        let defaults = UserDefaults(suiteName: DEFAULTS_NAME)
        
        if let d = defaults?.integer(forKey: "league") {
            return d
        }
        else{
            return 1
        }
    }
    
    func saveLeague(_ data:Int)
    {
        
        let defaults = UserDefaults(suiteName: DEFAULTS_NAME)
        
        defaults?.setValue(data, forKey: "league")
        
        defaults?.synchronize()
    }
    
}

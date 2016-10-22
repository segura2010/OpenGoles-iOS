//
//  Match.swift
//  OpenGoles
//
//  Created by Alberto on 22/10/16.
//  Copyright © 2016 Alberto. All rights reserved.
//

import Foundation

class Match{
    
    var score:String!
    var local:String!
    var visitor:String!
    var date:Date!
    
    var TV:String!
    var actMinute:String!
    var state:Int!
    
    init(_ d: [String:AnyObject]){
        
        score = d["score"] as! String
        local = d["teamLocal"] as! String
        visitor = d["teamVisitor"] as! String
        TV = d["listTV"] as! String
        state = d["matchState"] as! Int
        
        if let m = d["minutes"] as? String{
            actMinute = m
        }
        
        let secondsDate = ((d["dateMatch"] as! Int) / 1000) //- (3600 * 15) // to seconds and substract 15 hours
        date = Date(timeIntervalSince1970: TimeInterval(secondsDate))
        
    }
    
}

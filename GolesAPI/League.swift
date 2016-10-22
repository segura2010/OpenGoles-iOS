//
//  League.swift
//  OpenGoles
//
//  Created by Alberto on 22/10/16.
//  Copyright © 2016 Alberto. All rights reserved.
//

import Foundation


class League{
    
    var name:String!
    var id:Int!
    
    init(_ d: [String:AnyObject]){
        
        if let messageList = d["messageList"] as? [[String:AnyObject]]{
            if let m0 = messageList[0] as? [String:AnyObject]{
                name = m0["description"] as! String!
            }
        }
        
        id = d["idLeague"] as! Int
        
    }
    
}

//
//  MatchDetailsIC.swift
//  OpenGoles
//
//  Created by Alberto on 22/10/16.
//  Copyright © 2016 Alberto. All rights reserved.
//

import WatchKit
import Foundation

class MatchDetailsIC: WKInterfaceController {
    @IBOutlet var goalsTable: WKInterfaceTable!
    @IBOutlet var loadingLbl: WKInterfaceLabel!
    
    var match = [String:AnyObject]()
    var matchDetails = [String:AnyObject]()
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        goalsTable.setNumberOfRows(0, withRowType: "row")
        
        // Configure interface objects here.
        match = context as! [String:AnyObject]
        GolesAPI.sharedInstance.getEventsByMatch(match["idMatch"] as! Int) { (err, resp) in
            
            if err != nil{
                self.dismiss()
                return
            }
            
            self.matchDetails = resp!
            
            // Main UI Thread
            DispatchQueue.main.async(execute: { () -> Void in
                self.loadingLbl.setHidden(true)
                self.reloadTableData()
            })
            
        }
        
    }
    
    func reloadTableData(){
        if let events = matchDetails["eventList"] as? [[String:AnyObject]]{
            
            goalsTable.setNumberOfRows(events.count, withRowType: "row")
            
            for i in (0..<events.count){
                let eventMessageList = events[i]["eventMessageList"] as? [[String:AnyObject]]
                let desc = eventMessageList?[0]["description"] as! String
                let min = events[i]["timeMatch"] as! String
                let row = goalsTable.rowController(at: i) as? DetailRowController
                
                let eventType = events[i]["idEvent"] as! Int
                switch eventType {
                case EventType.yellowCard.rawValue:
                    row?.eventDescriptionLbl.setTextColor(UIColor.yellow)
                case EventType.redCard.rawValue:
                    row?.eventDescriptionLbl.setTextColor(UIColor.red)
                case EventType.goal.rawValue:
                    row?.eventDescriptionLbl.setTextColor(UIColor.cyan)
                default:
                    row?.eventDescriptionLbl.setTextColor(UIColor.white)
                }
                
                row?.eventDescriptionLbl.setText(desc)
                row?.eventTimeLbl.setText("\(min)'")
                
            }
            
        }else{
            goalsTable.setNumberOfRows(0, withRowType: "row")
        }
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
}

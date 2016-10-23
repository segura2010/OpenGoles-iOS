//
//  ClassificationInterfaceController.swift
//  OpenGoles
//
//  Created by Alberto on 23/10/16.
//  Copyright © 2016 Alberto. All rights reserved.
//

import Foundation
import WatchKit

class ClassificationInterfaceController: WKInterfaceController {
    @IBOutlet var tableView: WKInterfaceTable!
    
    var classification = [[String:AnyObject]]()
    
    var leagueId = 0
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        
        classification = context as! [[String : AnyObject]]
        reloadTableData()
        
    }
    
    func reloadTableData(){
        
        tableView.setNumberOfRows(classification.count, withRowType: "row")
        for i in (0..<classification.count){
            let team = classification[i] as! [String:AnyObject]
            let name = getShortName(team["name"] as! String).uppercased()
            let pos = i + 1
            let points = team["points"] as! Int
            let color = team["orderColor"] as! Int
            
            let row = tableView.rowController(at: i) as? ClassificationRow
            
            row?.teamLbl.setText("\(pos). \(name)")
            row?.pointsLbl.setText("\(points)")
            
            switch color {
            case 0:
                // champions
                row?.teamLbl.setTextColor(UIColor.cyan)
            case 1:
                // europa league/others
                row?.teamLbl.setTextColor(UIColor.orange)
            case 2:
                // descent
                row?.teamLbl.setTextColor(UIColor.red)
            default:
                row?.teamLbl.setTextColor(UIColor.white)
            }
            
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
    
    func getShortName(_ name:String) -> String{
        
        var newName = name.replacingOccurrences(of: " ", with: "")
        newName = newName.replacingOccurrences(of: ".", with: "")
        let endIndex = newName.index(newName.startIndex, offsetBy: 2)
        return newName[newName.startIndex...endIndex]
        
    }
    
}

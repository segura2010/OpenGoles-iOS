//
//  InterfaceController.swift
//  watch Extension
//
//  Created by Alberto on 22/10/16.
//  Copyright © 2016 Alberto. All rights reserved.
//

import WatchKit
import Foundation

import WatchConnectivity


class InterfaceController: WKInterfaceController {
    @IBOutlet var tableView: WKInterfaceTable!
    
    var fixturesList = [String:AnyObject]()
    
    var session = WCSession.default()
    
    var leagueId = 1

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        
        tableView.setNumberOfRows(fixturesList.count, withRowType: "row")
        
        session.delegate = self
        session.activate()
        
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func getNextLeagueFixtures() {
        GolesAPI.sharedInstance.getNextFixtures(self.leagueId, onCompletion: { (err, resp) in
            if err != nil{
                print(err)
                return
            }
            
            if let nextFixturesList = resp?["nextFixturesList"] as? [[String:AnyObject]]{
                if let nextFixtures = nextFixturesList[0] as? [String:AnyObject]{
                    self.fixturesList = nextFixtures
                    
                    // Main UI Thread
                    DispatchQueue.main.async(execute: { () -> Void in
                        self.reloadTableData()
                    })
                }
            }
            
        })
    }
    
    func getShortName(_ name:String) -> String{
        
        var newName = name.replacingOccurrences(of: " ", with: "")
        newName = newName.replacingOccurrences(of: ".", with: "")
        let endIndex = newName.index(newName.startIndex, offsetBy: 2)
        return newName[newName.startIndex...endIndex]
        
    }
    
    func reloadTableData(){
        tableView.setNumberOfRows(fixturesList.count, withRowType: "row")
        
        if let fixtures = fixturesList["fixtureMatchList"] as? [[String:AnyObject]]{
            for i in (0..<fixtures.count){
                let score = fixtures[i]["score"]
                let row = tableView.rowController(at: i) as? RowController
                let local = getShortName(fixtures[i]["teamLocal"] as! String).uppercased()
                let visitor = getShortName(fixtures[i]["teamVisitor"] as! String).uppercased()
                
                let text = "\(local) \(score!) \(visitor)"
                
                
                row?.matchLbl.setText(text)
                
                let matchState = fixtures[i]["matchState"] as! Int
                switch matchState {
                case MatchState.finished.rawValue:
                    row?.matchLbl.setTextColor(UIColor.red)
                case MatchState.notStarted.rawValue:
                    row?.matchLbl.setTextColor(UIColor.white)
                case MatchState.inGame.rawValue:
                    row?.matchLbl.setTextColor(UIColor.yellow)
                default:
                    row?.matchLbl.setTextColor(UIColor.white)
                }
            }
        }
    }

}

extension InterfaceController: WCSessionDelegate{
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
        if activationState == .activated{
            self.session.sendMessage(["league":0], replyHandler: nil, errorHandler: nil)
        }
        
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        
        if let data = message["league"] as? Int{
            self.leagueId = data
            getNextLeagueFixtures()
        }else if let data = message["error"] as? [String:Any]{
            print("Error...")
        }
        
    }
    
}

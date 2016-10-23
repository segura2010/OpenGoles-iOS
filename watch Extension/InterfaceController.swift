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
    @IBOutlet var loadingLbl: WKInterfaceLabel!
    
    var fixturesList = [String:AnyObject]()
    var classification = [[String:AnyObject]]()
    
    var session = WCSession.default()
    
    var leagueId = 0

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        
        tableView.setNumberOfRows(fixturesList.count, withRowType: "row")
        
        session.delegate = self
        session.activate()
        
        if leagueId != 0{
            getNextLeagueFixtures()
        }
        
        addMenuItem(with: .resume, title: "Refresh", action: #selector(refreshLeague))
        addMenuItem(with: .more, title: "Classification", action: #selector(showClassification))
        
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func refreshLeague(){
        if self.session.activationState == .activated && self.session.isReachable{
            self.loadingLbl.setHidden(false)
            self.session.sendMessage(["league":0], replyHandler: nil, errorHandler: nil)
        }else{
            getNextLeagueFixtures()
        }
    }
    
    func showClassification(){
        self.presentController(withName: "classificationInterface", context: classification)
    }
    
    func getNextLeagueFixtures() {
        self.loadingLbl.setHidden(false)
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
                        self.loadingLbl.setHidden(true)
                        self.reloadTableData()
                    })
                }
            }
            
            if let classif = resp?["classification"] as? [String:AnyObject]{
                if let classifs = classif["classifications"] as? [[String:AnyObject]]{
                    self.classification = classifs
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
        
        if let fixtures = fixturesList["fixtureMatchList"] as? [[String:AnyObject]]{
            tableView.setNumberOfRows(fixtures.count, withRowType: "row")
            for i in (0..<fixtures.count){
                var score = fixtures[i]["score"]
                let row = tableView.rowController(at: i) as? RowController
                let local = getShortName(fixtures[i]["teamLocal"] as! String).uppercased()
                let visitor = getShortName(fixtures[i]["teamVisitor"] as! String).uppercased()
                
                let secondsDate = ((fixtures[i]["dateMatch"] as! Int) / 1000) - (3600 * 15) // to seconds and substract 15 hours
                let matchDate = Date(timeIntervalSince1970: TimeInterval(secondsDate))
                let formatter = DateFormatter()
                formatter.dateFormat = "EEEE, HH:mm"
                var dateStr = formatter.string(from: matchDate)
                
                let matchState = fixtures[i]["matchState"] as! Int
                switch matchState {
                case MatchState.finished.rawValue:
                    row?.matchLbl.setTextColor(UIColor.red)
                case MatchState.notStarted.rawValue:
                    score = "-" as AnyObject?
                    row?.matchLbl.setTextColor(UIColor.white)
                case MatchState.inGame.rawValue:
                    dateStr = "\(fixtures[i]["minutes"]!)'"
                    row?.matchLbl.setTextColor(UIColor.yellow)
                default:
                    row?.matchLbl.setTextColor(UIColor.white)
                }
                
                let text = "\(local) \(score!) \(visitor)"
                
                
                row?.matchLbl.setText(text)
                row?.dateLbl.setText(dateStr)
            }
        }
    }
    
    // Segue
    override func contextForSegue(withIdentifier segueIdentifier: String, in table: WKInterfaceTable, rowIndex: Int) -> Any? {
        
        if let fixtures = fixturesList["fixtureMatchList"] as? [[String:AnyObject]]{
            if let match = fixtures[rowIndex] as? [String:AnyObject]{
                return match
            }
            return nil
        }
        return nil
        
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


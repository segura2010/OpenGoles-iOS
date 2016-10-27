//
//  MatchDetailsVC.swift
//  OpenGoles
//
//  Created by Alberto on 27/10/16.
//  Copyright © 2016 Alberto. All rights reserved.
//

import Foundation
import UIKit

class MatchDetailsVC: UIViewController, UITableViewDelegate, UITableViewDataSource{
    @IBOutlet var tableView: UITableView!
    
    var matchEvents = [MatchEvent]()
    var match:Match!
    
    override func viewDidLoad() {
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.automaticallyAdjustsScrollViewInsets = false
        self.title = "\(match.local!) - \(match.visitor!)"
        
        GolesAPI.sharedInstance.getEventsByMatch(match.id) { (err, resp) in
            
            if err != nil{
                return
            }
            
            if let events = resp?["eventList"] as? [[String:AnyObject]]{
                self.matchEvents.removeAll()
                for e in events{
                    let ev = MatchEvent(e)
                    self.matchEvents.append(ev)
                }
                
                // Main UI Thread
                DispatchQueue.main.async(execute: { () -> Void in
                    self.tableView.reloadData()
                })
            }
            
        }
        
    }
    
    // TableView Delegate Functions
    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int
    {
        return matchEvents.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath) as? DetailCell{
            cell.configureCell(self.matchEvents[indexPath.row])
            return cell
        }else{
            return MatchCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

//
//  LeagueSelectorVC.swift
//  OpenGoles
//
//  Created by Alberto on 22/10/16.
//  Copyright © 2016 Alberto. All rights reserved.
//

import Foundation
import UIKit

class LeagueSelectorVC: UIViewController, UITableViewDelegate, UITableViewDataSource{
    @IBOutlet var tableView: UITableView!
    
    var leagues = [League]()
    
    override func viewDidLoad() {
        
        tableView.delegate = self
        tableView.dataSource = self
        
        GolesAPI.sharedInstance.getLeagues { (err, resp) in
            if err != nil{
                self.dismiss(animated: true, completion: nil)
                return
            }
            
            if let jsonLeagues = resp?["leagues"] as? [[String:AnyObject]]{
                self.leagues.removeAll()
                for l in jsonLeagues{
                    let newLeague = League(l)
                    self.leagues.append(newLeague)
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
        return self.leagues.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeagueCell", for: indexPath)
        
        cell.textLabel?.text = leagues[indexPath.row].name
        
        let leagueId = LocalStorageManager.sharedInstance.getLeague()
        if leagueId == leagues[indexPath.row].id{
            cell.textLabel?.textColor = UIColor.blue
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        LocalStorageManager.sharedInstance.saveLeague( self.leagues[indexPath.row].id )
        self.dismiss(animated: true, completion: nil)
        
    }
    
}

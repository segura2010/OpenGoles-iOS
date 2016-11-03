//
//  FirstViewController.swift
//  OpenGoles
//
//  Created by Alberto on 22/10/16.
//  Copyright © 2016 Alberto. All rights reserved.
//

import UIKit

class FirstViewController: UITableViewController {
    
    var idLeague = 1
    var matches = [Match]()
    var leagues = [League]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        refreshData()
        // get leagues
        GolesAPI.sharedInstance.getLeagues { (err, resp) in
            if err != nil{
                return
            }
            
            if let jsonLeagues = resp?["leagues"] as? [[String:AnyObject]]{
                self.leagues.removeAll()
                for l in jsonLeagues{
                    let newLeague = League(l)
                    self.leagues.append(newLeague)
                }
            }
            
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func refreshData(){
        idLeague = LocalStorageManager.sharedInstance.getLeague()
        if idLeague < 1{
            idLeague = 1
        }
        GolesAPI.sharedInstance.getNextFixtures(idLeague) { (err, resp) in
            
            if err != nil{
                return
            }
            
            self.loadData(resp!)
            
        }
    }
    
    func loadData(_ data: [String:AnyObject]){
        
        if let nextFixturesList = data["nextFixturesList"] as? [[String:AnyObject]]{
            if let nextFixtures = nextFixturesList[0] as? [String:AnyObject]{
                let jsonMatches = nextFixtures["fixtureMatchList"] as? [[String:AnyObject]]
                
                self.matches.removeAll()
                for m in jsonMatches!{
                    let newMatch = Match(m)
                    self.matches.append(newMatch)
                }
                
                // Main UI Thread
                DispatchQueue.main.async(execute: { () -> Void in
                    self.tableView.reloadData()
                    self.showAnimateTable()
                })
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // TableView Delegate Functions
    override func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int
    {
        return self.matches.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MatchCell", for: indexPath) as? MatchCell{
            cell.configureCell(self.matches[indexPath.row])
            return cell
        }else{
            return MatchCell()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "showLeagueSelector"{
            var vc = segue.destination as! LeagueSelectorVC
            // Prepare style
            var controller = vc.popoverPresentationController
            controller?.delegate = vc
            
            // prepare leagues
            vc.leagues = self.leagues
            
            return
            
        }
        
        let MDetailsVC = segue.destination as! MatchDetailsVC
        if let indexPath = self.tableView.indexPath(for: sender as! UITableViewCell){
            if((indexPath as NSIndexPath).row < matches.count){
                let m = matches[(indexPath as NSIndexPath).row]
                MDetailsVC.match = m
            }
        }
        
    }
    
    
    @IBAction func configureLeagueBtnClick(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "showLeagueSelector", sender: self)
    }

    @IBAction func refreshBtnClick(_ sender: AnyObject) {
        hideAnimateTable()
    }

    
    
    // Funny animations! 
    // Thanks to: https://github.com/brianadvent/SimpleAnimations
    func showAnimateTable() {
        
        let cells = tableView.visibleCells
        let tableViewHeight = tableView.bounds.size.height
        
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: 0, y: tableViewHeight)
        }
        
        var delayCounter = 0
        for cell in cells {
            UIView.animate(withDuration: 1.25, delay: Double(delayCounter) * 0.05, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                cell.transform = CGAffineTransform.identity
                }, completion: nil)
            delayCounter += 1
        }
        
    }
    func hideAnimateTable() {
        
        let cells = tableView.visibleCells
        let tableViewHeight = tableView.bounds.size.height
        
        var delayCounter = 0
        for i in (0..<cells.count) {
            let cell = cells[i]
            UIView.animate(withDuration: 1.25, delay: Double(delayCounter) * 0.05, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: -tableViewHeight)
            }){ (success) in
                cell.transform = CGAffineTransform.identity
                cell.isHidden = true
                
                if i == cells.count-1{
                    // if is the last cell, reload data
                    self.refreshData()
                }
            }
            delayCounter += 1
        }
        
    }
    
}


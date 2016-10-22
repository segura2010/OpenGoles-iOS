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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        refreshData()
        
    }
    
    func refreshData(){
        idLeague = LocalStorageManager.sharedInstance.getLeague()
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
    
    @IBAction func configureLeagueBtnClick(_ sender: UIBarButtonItem) {
        
        let leagueSelectorVC = storyboard?.instantiateViewController(withIdentifier: "leagueSelectorVC") as! LeagueSelectorVC
        
        self.present(leagueSelectorVC, animated: true, completion: nil)
        
    }

    @IBAction func refreshBtnClick(_ sender: AnyObject) {
        refreshData()
    }
}


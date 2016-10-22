//
//  MatchCell.swift
//  OpenGoles
//
//  Created by Alberto on 22/10/16.
//  Copyright © 2016 Alberto. All rights reserved.
//

import Foundation
import UIKit

class MatchCell: UITableViewCell {
    @IBOutlet var matchTitleLbl: UILabel!
    @IBOutlet var tvLbl: UILabel!
    @IBOutlet var dateLbl: UILabel!
    
    
    
    func configureCell(_ m:Match)
    {
        tvLbl.text = m.TV
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, HH:mm"
        var dateStr = formatter.string(from: m.date)
        
        var score = m.score
        
        switch m.state {
        case MatchState.finished.rawValue:
            matchTitleLbl.textColor = UIColor.red
        case MatchState.notStarted.rawValue:
            score = "-"
            matchTitleLbl.textColor = UIColor.black
        case MatchState.inGame.rawValue:
            dateStr = "\(m.actMinute!)'"
            matchTitleLbl.textColor = UIColor.blue
        default:
            matchTitleLbl.textColor = UIColor.black
        }
        
        dateLbl.text = dateStr
        
        matchTitleLbl.text = "\(m.local!) \(score!) \(m.visitor!)"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    
}

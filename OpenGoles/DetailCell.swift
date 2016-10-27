//
//  DetailCell.swift
//  OpenGoles
//
//  Created by Alberto on 27/10/16.
//  Copyright © 2016 Alberto. All rights reserved.
//

import Foundation
import UIKit

class DetailCell: UITableViewCell {
    @IBOutlet var eventImage: UIImageView!
    @IBOutlet var descriptionLbl: UILabel!
    @IBOutlet var minuteLbl: UILabel!
    
    func configureCell(_ m:MatchEvent)
    {
        minuteLbl.text = "\(m.minute!)'"
        
        descriptionLbl.text = m.description
        
        imageView?.isHidden = false
        let eventType = m.eventType!
        switch eventType {
        case EventType.yellowCard.rawValue:
            descriptionLbl.textColor = UIColor(red: 222/255, green: 207/255, blue: 8/255, alpha: 1)
            imageView?.image = #imageLiteral(resourceName: "yellow_card")
        case EventType.redCard.rawValue:
            descriptionLbl.textColor = UIColor(red: 223/255, green: 52/255, blue: 46/255, alpha: 1)
            imageView?.image = #imageLiteral(resourceName: "red_card")
        case EventType.goal.rawValue:
            descriptionLbl.textColor = UIColor.cyan
            imageView?.image = #imageLiteral(resourceName: "ball")
        default:
            descriptionLbl.textColor = UIColor.black
            imageView?.isHidden = true
        }
        
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

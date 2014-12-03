//
//  NotificationTableViewCell.swift
//  SocialJournal
//
//  Created by Gabe on 11/28/14.
//  Copyright (c) 2014 UH. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var notifcationLabel: UILabel!
    @IBOutlet weak var fromUserPicture: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 10
        
        self.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.layer.borderWidth = 1.0
        
        self.fromUserPicture.layer.cornerRadius = 50
        self.fromUserPicture.layer.masksToBounds = true
        self.fromUserPicture.layer.borderColor = UIColor.whiteColor().CGColor
        self.fromUserPicture.layer.borderWidth = 1.0
        
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

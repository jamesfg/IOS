//
//  SearchUserCell.swift
//  SocialJournal
//
//  Created by Muhammad Naviwala on 11/29/14.
//  Copyright (c) 2014 UH. All rights reserved.
//

import UIKit

class SearchUserCell: UITableViewCell {

    @IBOutlet weak var userProfilePicture: UIImageView!
    @IBOutlet weak var userName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.userProfilePicture.layer.cornerRadius = self.userProfilePicture.frame.size.width / 2;
        self.userProfilePicture.clipsToBounds = true;
        self.userProfilePicture.layer.borderWidth = 1.0
        self.userProfilePicture.layer.borderColor = UIColor.lightGrayColor().CGColor;
        
        self.backgroundColor = UIColor.clearColor()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

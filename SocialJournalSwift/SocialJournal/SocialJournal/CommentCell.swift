//
//  CommentCell.swift
//  SocialJournal
//
//  Created by Muhammad Naviwala on 12/1/14.
//  Copyright (c) 2014 UH. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {

    @IBOutlet weak var userProfilePicture: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var theComment: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.userProfilePicture.layer.cornerRadius = self.userProfilePicture.frame.size.width / 2;
        self.userProfilePicture.clipsToBounds = true;
        self.userProfilePicture.layer.borderWidth = 1.0
        self.userProfilePicture.layer.borderColor = UIColor.lightGrayColor().CGColor;
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

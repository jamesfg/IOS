//
//  VirtualNameTableViewCell.swift
//  SocialJournal
//
//  Created by Xiaolu Zhang on 12/2/14.
//  Copyright (c) 2014 UH. All rights reserved.
//

import UIKit

class VirtualNameTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var keyword: UILabel!
    
    @IBOutlet weak var virtualName: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

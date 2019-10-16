//
//  GroupChatTableViewCell.swift
//  matchness
//
//  Created by 中村篤史 on 2019/10/14.
//  Copyright © 2019 a2c. All rights reserved.
//

import UIKit

class GroupChatTableViewCell: UITableViewCell {

    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var created_at: UILabel!   
    @IBOutlet weak var comment: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

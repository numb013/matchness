//
//  ChatTableViewCell.swift
//  matchness
//
//  Created by user on 2019/06/07.
//  Copyright © 2019 a2c. All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell {

    @IBOutlet weak var ChatImage: UIImageView!
    @IBOutlet weak var ChatName: UILabel!
    @IBOutlet weak var ChatMessage: UILabel!
    @IBOutlet weak var ChatDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

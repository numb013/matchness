//
//  NoticeTableViewCell.swift
//  matchness
//
//  Created by 中村篤史 on 2020/03/16.
//  Copyright © 2020 a2c. All rights reserved.
//

import UIKit

class NoticeTableViewCell: UITableViewCell {

    @IBOutlet weak var dateTime: UILabel!
    @IBOutlet weak var noticeText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

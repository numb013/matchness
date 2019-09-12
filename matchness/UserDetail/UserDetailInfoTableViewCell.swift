//
//  UserDetailInfoTableViewCell.swift
//  matchness
//
//  Created by 中村篤史 on 2019/08/09.
//  Copyright © 2019 a2c. All rights reserved.
//

import UIKit

class UserDetailInfoTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var detail: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

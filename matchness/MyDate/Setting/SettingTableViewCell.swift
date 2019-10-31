//
//  SettingTableViewCell.swift
//  matchness
//
//  Created by 中村篤史 on 2019/10/29.
//  Copyright © 2019 a2c. All rights reserved.
//

import UIKit

class SettingTableViewCell: UITableViewCell {

    @IBOutlet weak var swichButton: UISwitch!
    @IBOutlet weak var settingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

//
//  TextFiledTableViewCell.swift
//  matchness
//
//  Created by 中村篤史 on 2019/09/01.
//  Copyright © 2019 a2c. All rights reserved.
//

import UIKit

class TextFiledTableViewCell: UITableViewCell {

    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var textFiled: UITextField!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

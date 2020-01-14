//
//  PointHistoryTableViewCell.swift
//  matchness
//
//  Created by 中村篤史 on 2020/01/08.
//  Copyright © 2020 a2c. All rights reserved.
//

import UIKit

class PointHistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var point: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var created: UILabel!
    @IBOutlet weak var p_text: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

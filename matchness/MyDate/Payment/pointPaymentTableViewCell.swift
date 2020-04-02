//
//  pointPaymentTableViewCell.swift
//  matchness
//
//  Created by 中村篤史 on 2019/12/04.
//  Copyright © 2019 a2c. All rights reserved.
//

import UIKit

class pointPaymentTableViewCell: UITableViewCell {

    @IBOutlet weak var point: UILabel!
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var pointPaymentImage: UIImageView!
    
    @IBOutlet weak var unit: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

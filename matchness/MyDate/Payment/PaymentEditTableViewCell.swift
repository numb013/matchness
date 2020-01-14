//
//  PaymentEditTableViewCell.swift
//  matchness
//
//  Created by 中村篤史 on 2019/12/30.
//  Copyright © 2019 a2c. All rights reserved.
//

import UIKit
protocol CellDelegate {
    func buttonDidTap()
}

class PaymentEditTableViewCell: UITableViewCell {
    var delegate: CellDelegate!
    @IBOutlet weak var company_img: UIImageView!
    @IBOutlet weak var card_company: UILabel!
    @IBOutlet weak var card_no: UILabel!
    @IBOutlet weak var expiration_date: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
}

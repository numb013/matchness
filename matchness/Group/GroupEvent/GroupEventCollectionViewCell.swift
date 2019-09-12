//
//  GroupEventCollectionViewCell.swift
//  matchness
//
//  Created by user on 2019/06/22.
//  Copyright © 2019 a2c. All rights reserved.
//

import UIKit

class GroupEventCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var lastLoginTime: UILabel!
    @IBOutlet weak var userInfo: UILabel!
    @IBOutlet weak var userStep: UILabel!
    @IBOutlet weak var step: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

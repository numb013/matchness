//
//  SectionHeaderView.swift
//  accordion-menu-sample
//
//  Created by 櫻井寛海 on 2018/07/25.
//  Copyright © 2018 Hiromi Sakurai. All rights reserved.
//

import UIKit

class SectionHeaderView: UITableViewHeaderFooterView {

    var tappedHandler: ((Int) -> Void)?
    var section: Int?

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelected)))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func config(title: String, section: Int, tappedHandler: @escaping (Int) -> Void) {
        self.textLabel?.text = title
        self.section = section
        self.tappedHandler = tappedHandler
    }

    @objc private func handleSelected(gestureRecognizer: UITapGestureRecognizer) {
        guard let headerView = gestureRecognizer.view as? SectionHeaderView,
            let section = headerView.section,
            let tappedHandler = tappedHandler else { return }
        tappedHandler(section)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

//        let startColor = UIColor(white: 1.0, alpha: 0.7).cgColor
//        let endColor = UIColor(white: 0.8, alpha: 0.3).cgColor
//        let layer = CAGradientLayer()
//        layer.colors = [startColor, endColor]
//        layer.frame = contentView.bounds


        let buttomBorder = CALayer()
        buttomBorder.frame = CGRect(x: 0, y: self.frame.height - 1, width: self.frame.width, height: 0.5)
        buttomBorder.backgroundColor = UIColor.lightGray.cgColor

        contentView.layer.addSublayer(buttomBorder)
        textLabel?.textColor = #colorLiteral(red: 0.3726522326, green: 0.3743820786, blue: 0.3785918653, alpha: 1)
        contentView.backgroundColor = #colorLiteral(red: 0.9683176875, green: 0.9684795737, blue: 0.968296349, alpha: 1)
    }
}

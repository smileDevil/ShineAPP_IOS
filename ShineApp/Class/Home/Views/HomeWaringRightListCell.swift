//
//  HomeWaringRightListCell.swift
//  ShineApp
//
//  Created by jiang.123 on 2020/12/18.
//  Copyright © 2020 jiang.123. All rights reserved.
//

import UIKit

class HomeWaringRightListCell: UITableViewCell {
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label4: UILabel!
    @IBOutlet weak var label5: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
           bgView.clipsToBounds = true
             bgView.layer.cornerRadius = CGFloat(clickRadius)
             bgView.backgroundColor = cellBgColor
             self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

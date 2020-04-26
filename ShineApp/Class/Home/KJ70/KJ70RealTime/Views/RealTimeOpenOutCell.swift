//
//  RealTimeOpenOutCell.swift
//  ShineApp
//
//  Created by jiang.123 on 2020/4/2.
//  Copyright © 2020 jiang.123. All rights reserved.
//

import UIKit

class RealTimeOpenOutCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var numLabel: UILabel!
    @IBOutlet weak var typeNameLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        bgView.clipsToBounds = true
        bgView.backgroundColor = cellBgColor
        bgView.layer.cornerRadius = CGFloat(clickRadius)
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

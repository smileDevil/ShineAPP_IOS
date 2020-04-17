//
//  RealTimeEquipmentCell.swift
//  ShineApp
//
//  Created by jiang.123 on 2020/4/1.
//  Copyright © 2020 jiang.123. All rights reserved.
//

import UIKit
class RealTimeEquipmentCell: UITableViewCell {
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var numLabel: UILabel!
    @IBOutlet weak var typeNameLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var unitLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        bgView.clipsToBounds = true
        bgView.layer.cornerRadius = CGFloat(clickRadius)
        self.selectionStyle = .none
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

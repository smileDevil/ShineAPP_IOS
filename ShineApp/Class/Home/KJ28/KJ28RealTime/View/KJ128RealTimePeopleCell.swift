//
//  KJ128RealTimePeopleCell.swift
//  ShineApp
//
//  Created by jiang.123 on 2020/4/21.
//  Copyright © 2020 jiang.123. All rights reserved.
//

import UIKit

class KJ128RealTimePeopleCell: UITableViewCell {
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var peopleNameLabel: UILabel!
    @IBOutlet weak var cardNumLabel: UILabel!
    @IBOutlet weak var departmentLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var inTimeLabel: UILabel!
    @IBOutlet weak var continuoustime: UILabel!
    
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

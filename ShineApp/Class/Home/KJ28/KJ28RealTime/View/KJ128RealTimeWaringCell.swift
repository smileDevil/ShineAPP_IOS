//
//  KJ128RealTimeWaringCell.swift
//  ShineApp
//
//  Created by jiang.123 on 2020/4/27.
//  Copyright © 2020 jiang.123. All rights reserved.
//

import UIKit

class KJ128RealTimeWaringCell: UITableViewCell {
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var minelabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var jobcardLabel: UILabel!
    @IBOutlet weak var departmentLabel: UILabel!
    @IBOutlet weak var areaNameLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var beginTimelabel: UILabel!
    @IBOutlet weak var continuousLabel: UILabel!
    
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

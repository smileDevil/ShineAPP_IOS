//
//  HistoryWaringCell.swift
//  ShineApp
//
//  Created by jiang.123 on 2020/4/9.
//  Copyright © 2020 jiang.123. All rights reserved.
//

import UIKit

class HistoryWaringCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var placelabel: UILabel!
    @IBOutlet weak var waringStatelabel: UILabel!
    @IBOutlet weak var sensorNumLabel: UILabel!
    @IBOutlet weak var valLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var beginTimeLabel: UILabel!
    @IBOutlet weak var contiousLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        bgView.clipsToBounds = true
        bgView.layer.cornerRadius = CGFloat(clickRadius)
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

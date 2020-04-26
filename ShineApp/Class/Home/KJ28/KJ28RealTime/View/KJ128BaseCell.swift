//
//  KJ128BaseCell.swift
//  ShineApp
//
//  Created by jiang.123 on 2020/4/24.
//  Copyright © 2020 jiang.123. All rights reserved.
//

import UIKit

class KJ128BaseCell: UITableViewCell {
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var baseLabelOne: UILabel!
    @IBOutlet weak var baseLabelTwo: UILabel!
    @IBOutlet weak var baseLabelThr: UILabel!
    @IBOutlet weak var baseLabelfor: UILabel!
    @IBOutlet weak var baseLabelFiv: UILabel!
    @IBOutlet weak var baseSixView: UIView!
    @IBOutlet weak var baseLabelSix: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
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

	//
//  HomeWaringListCell.swift
//  ShineApp
//
//  Created by jiang.123 on 2020/12/18.
//  Copyright © 2020 jiang.123. All rights reserved.
//

import UIKit

class HomeWaringListCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var titlleLabel: UILabel!
    @IBOutlet weak var rightImageView: UIImageView!
    @IBOutlet weak var bottomLineView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        bgView.backgroundColor = cellBgColor
//        self.selectionStyle = .none
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

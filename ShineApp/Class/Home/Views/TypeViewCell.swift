//
//  TypeViewCell.swift
//  ShineApp
//
//  Created by jiang.123 on 2020/3/31.
//  Copyright © 2020 jiang.123. All rights reserved.
//

import UIKit

class TypeViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
//
}

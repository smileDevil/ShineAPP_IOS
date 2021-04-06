//
//  NotificationCell.swift
//  ShineApp
//
//  Created by jiang.123 on 2020/12/19.
//  Copyright © 2020 jiang.123. All rights reserved.
//

import UIKit

class NotificationCell: UITableViewCell {

   @IBOutlet weak var bgView: UIView!
       @IBOutlet weak var labelTitle: UILabel!
       @IBOutlet weak var labelState: UILabel!
       @IBOutlet weak var labelContent: UILabel!
       @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var contentLineHeight: NSLayoutConstraint!
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

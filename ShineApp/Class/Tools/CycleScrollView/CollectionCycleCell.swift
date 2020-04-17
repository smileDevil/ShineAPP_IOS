//
//  CollectionCycleCell.swift
//  DYZB
//
//  Created by 1 on 16/9/21.
//  Copyright © 2016年 小码哥. All rights reserved.
//

import UIKit
import Kingfisher

class CollectionCycleCell: UICollectionViewCell {
    
    // MARK: 控件属性
    @IBOutlet weak var iconImageView: UIImageView!
//    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: 定义模型属性
    var cycleModel : CycleModel? {
        didSet {
//            titleLabel.text = cycleModel?.game_name
            let iconUrl = URL(string: cycleModel?.vertical_src ?? "")!
            iconImageView.kf.setImage(with: iconUrl)
        }
    }
    
    var cycleDic : [String : AnyObject] = [:]{
        didSet{
         
            
            var urlStr : String = cycleDic["url"] as! String
            if(urlStr == ""){
                urlStr =  "banner_main"
            }
            iconImageView.image = Image(named: urlStr)
        }
    }
}

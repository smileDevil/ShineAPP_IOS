//
//  TypeSelectView.swift
//  ShineApp
//
//  Created by jiang.123 on 2020/4/3.
//  Copyright © 2020 jiang.123. All rights reserved.
//

import UIKit

class TypeSelectView: UIView {

  
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var baView: UIView!
    @IBOutlet weak var typeNameLabel: UILabel!
    @IBOutlet weak var typeSelectBtn: UIButton!
    override init(frame: CGRect) {
         super.init(frame: frame)
         // 加载xib
        contentView = (Bundle.main.loadNibNamed("TypeSelectView", owner: self, options: nil)?.last as! UIView)
         // 设置frame
        contentView.frame = frame
        baView.clipsToBounds = true
        baView.layer.cornerRadius = 8
         // 添加上去
         addSubview(contentView)
     }
     
     required init?(coder aDecoder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }


}

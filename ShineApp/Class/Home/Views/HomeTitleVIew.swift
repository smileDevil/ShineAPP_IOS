//
//  HomeTitleVIew.swift
//  LWPT
//
//  Created by jiang.123 on 2020/9/16.
//  Copyright © 2020 jiang.123. All rights reserved.
//

import UIKit

class HomeTitleVIew: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
   
    override init(frame: CGRect) {
          super.init(frame: frame)
          // 加载xib
        contentView = (Bundle.main.loadNibNamed("HomeTitleVIew", owner: self, options: nil)?.last as! UIView)
          // 设置frame
        contentView.frame = frame
       // contentView.clipsToBounds = true
        //contentView.layer.cornerRadius = CGFloat(clickRadius)
          // 添加上去
          addSubview(contentView)
      }
      
      required init?(coder aDecoder: NSCoder) {
          fatalError("init(coder:) has not been implemented")
      }

}

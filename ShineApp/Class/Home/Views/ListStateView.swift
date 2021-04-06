//
//  ListStateView.swift
//  LWPT
//
//  Created by jiang.123 on 2020/4/6.
//  Copyright © 2020 jiang.123. All rights reserved.
//

import UIKit

class ListStateView: UIView {

    @IBOutlet var contentView: UIView!
    override init(frame: CGRect) {
        super.init(frame:frame)
        // 加载xib
             contentView = (Bundle.main.loadNibNamed("ListStateView", owner: self, options: nil)?.last as! UIView)
              // 设置frame
             contentView.frame = frame
              // 添加上去
              addSubview(contentView)
    }
       required init?(coder aDecoder: NSCoder) {
          fatalError("init(coder:) has not been implemented")
      }
}

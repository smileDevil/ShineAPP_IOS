//
//  TypeButtonView.swift
//  ShineApp
//
//  Created by jiang.123 on 2020/3/23.
//  Copyright © 2020 jiang.123. All rights reserved.
//

import UIKit

class TypeButtonView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var typelogImg: UIImageView!
    @IBOutlet weak var typeTitleLabel: UILabel!
    @IBOutlet weak var typeClickBtn: UIButton!
    
    
    override init(frame: CGRect) {
          super.init(frame: frame)
          // 加载xib
          contentView = (Bundle.main.loadNibNamed("TypeButtonView", owner: self, options: nil)?.last as! UIView)
          // 设置frame
          contentView.frame = frame
          // 添加上去
          addSubview(contentView)
      }
      
      required init?(coder aDecoder: NSCoder) {
          fatalError("init(coder:) has not been implemented")
      }

}

//
//  NavTitleView.swift
//  ShineApp
//
//  Created by jiang.123 on 2020/3/23.
//  Copyright © 2020 jiang.123. All rights reserved.
//

import UIKit

class NavTitleView: UIView {
    
    var titleBtn:UIButton?
    var arrImg:UIImageView?

    override init(frame: CGRect) {
        super.init(frame: frame)
        //初始化视图
        titleBtn = UIButton(frame: CGRect(x: 0, y: 0, width: frame.size.width-20, height: frame.size.height))
        titleBtn?.setTitle("实时数据", for: .normal)
        titleBtn?.titleLabel?.textColor = UIColor.white
        titleBtn?.titleLabel?.textAlignment = .right
//        titleBtn?.contentHorizontalAlignment = .right;
        self.addSubview(titleBtn!)
        arrImg = UIImageView(frame: CGRect(x: frame.size.width - 20 , y: (frame.size.height - 20) / 2, width: 20, height: 20))
        arrImg?.image = UIImage(named: "arrow_down")
        self.addSubview(arrImg!)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//
//  UIBarButtonItem-Extension.swift
//  DYZB
//
//  Created by jiang.123 on 2019/6/6.
//  Copyright © 2019年 jiang.123. All rights reserved.
//

import Foundation
import UIKit

//对UIBarButtonItem扩展
extension UIBarButtonItem {
    
    //类方法实现
//    class func createBarButtonItem(imageName:String , highImageName : String , size :CGSize) -> UIBarButtonItem {
//        let btn = UIButton()
//        btn.setImage(UIImage(named:imageName), for: .normal)
//        btn.setImage(UIImage(named:highImageName), for: .highlighted)
//        btn.sizeToFit()
//        return UIBarButtonItem(customView: btn)
//    }
    
    // 构造函数实现  1 convienience 开头  2 必须明确i调用一个设计的构造函数
    convenience init(imageName:String , highImageName : String , size :CGSize){
        let btn = UIButton()
        btn.setImage(UIImage(named:imageName), for: .normal)
        btn.setImage(UIImage(named:highImageName), for: .highlighted)
        btn.sizeToFit()
//        btn.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: size);
        self.init(customView: btn)
    }
}

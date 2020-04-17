//
//  UIImageView+Extension.swift
//  ShineApp
//
//  Created by jiang.123 on 2020/3/21.
//  Copyright © 2020 jiang.123. All rights reserved.
//

import Foundation
import UIKit
extension UIImageView{

func setCornerImage(){
    //异步绘制图像
DispatchQueue.global().async(execute: {
        //1.建立上下文
    
UIGraphicsBeginImageContextWithOptions(self.bounds.size, true, 0)

        //获取当前上下文
        let ctx = UIGraphicsGetCurrentContext()
        
        //设置填充颜色
        UIColor.white.setFill()
        UIRectFill(self.bounds)
        
        //2.添加圆及裁切
        ctx?.addEllipse(in: self.bounds)
        //裁切
        ctx?.clip()
        
        //3.绘制图像
        self.draw(self.bounds)
        
        //4.获取绘制的图像
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        //5关闭上下文
        UIGraphicsEndImageContext()
        
        DispatchQueue.main.async(execute: {
            self.image = image
        })
    })
}}

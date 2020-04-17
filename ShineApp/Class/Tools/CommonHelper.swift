//
//  CommonHelper.swift
//  ShineApp
//
//  Created by jiang.123 on 2020/3/21.
//  Copyright © 2020 jiang.123. All rights reserved.
//

import Foundation
import UIKit

//左右半圆裁剪
func SetAllBorderRoundingCorners(_ view:UIView,corner:CGFloat)

   {
       let maskPath = UIBezierPath.init(roundedRect: view.bounds,

//        byRoundingCorners: [UIRectCorner.bottomLeft,UIRectCorner.bottomRight, UIRectCorner.topRight,UIRectCorner.topLeft],
        byRoundingCorners:UIRectCorner.allCorners,
       cornerRadii: CGSize(width: corner, height: corner))
       let maskLayer = CAShapeLayer()
       maskLayer.frame = view.bounds
       maskLayer.path = maskPath.cgPath
       view.layer.mask = maskLayer
   }

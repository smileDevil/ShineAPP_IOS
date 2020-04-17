//
//  Common.swift
//  DYZB
//
//  Created by jiang.123 on 2019/6/10.
//  Copyright © 2019年 jiang.123. All rights reserved.
//

import Foundation
import UIKit


//let mStatusBarH : CGFloat = 20
//let mNavigationBarH : CGFloat = 44
//let mTabbarH : CGFloat = 44
let mScreenW = UIScreen.main.bounds.width
let mScreenH = UIScreen.main.bounds.height

// 屏幕宽度
let JYBWindowWidth = UIScreen.main.bounds.width

// 屏幕高度
let JYBWindowHeight = UIScreen.main.bounds.height

// iPhone4
let isIphone4 = JYBWindowHeight  < 568 ? true : false

// iPhone 5
let isIphone5 = JYBWindowHeight  == 568 ? true : false

// iPhone 6
let isIphone6 = JYBWindowHeight  == 667 ? true : false

// iphone 6P
let isIphone6P = JYBWindowHeight == 736 ? true : false

// iphone X
let isIphoneX = JYBWindowHeight >= 812 ? true : false

// navigationBarHeight
let navigationBarHeight : CGFloat = isIphoneX ? 88 : 64

// tabBarHeight
let tabBarHeight : CGFloat = isIphoneX ? 49 + 34 : 49

let iphoneXbottomHight : CGFloat = 34
// ka70datacontroll 中的顶部导航高度
let cvTopNavHeight = 40

let jCycleViewH = isIphoneX ? 200:160
let jCycleViewMarginTop = isIphoneX ? 40:20
let jCycleViewMargin = isIphoneX ? 30:30
let jCycleTopMargin = isIphoneX ? 45:30;
let typeViewMarginCycleView = isIphoneX ? 45:30

//颜色
let mainColor = UIColor.init(r: 26, g: 42, b: 54)
let cellBgColor = UIColor.init(r: 42, g: 53, b: 78)
let tabBarBgColor = cellBgColor
let tabBarItemSelectdColor = UIColor.init(r: 7, g: 193, b: 96) //绿色选中色
let tabbarItemNormalColor = UIColor.init(r: 113, g: 138, b: 148)
let greenColor =  tabBarItemSelectdColor //绿色选中色
let successColor = greenColor
let waringColor = UIColor.init(r: 213, g: 30, b: 26)
let errorColor = UIColor.init(r: 255, g: 174, b: 0)
// placeholdercolor
let placeholderColor = UIColor.init(r: 176, g: 195, b: 210)
let contentTextColor = UIColor.init(r: 255, g: 255, b: 255)
let lineColor = UIColor.init(r: 42, g: 53, b: 78)
//字号
let commonTextFontSize = UIFont.systemFont(ofSize: 14)
let frameTitleFontSize = UIFont.systemFont(ofSize: 16)
//view
// 统一cell 弧度
let clickRadius = 8

//url
let REQUESTURL = "http://172.16.19.127:10010/SHHWebService.asmx/"
//let REQUESTURL = "http://dev.3shine.com:8100/SHHWebService.asmx/"

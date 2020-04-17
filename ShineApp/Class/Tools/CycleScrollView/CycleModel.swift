//
//  CycleModel.swift
//  DYZB
//
//  Created by 1 on 16/9/21.
//  Copyright © 2016年 小码哥. All rights reserved.
//

import UIKit

@objcMembers
class CycleModel: NSObject {
    // 标题
    var game_name : String = ""
    // 展示的图片地址
    var vertical_src : String = ""
    
    init(dict:[String : NSObject]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}

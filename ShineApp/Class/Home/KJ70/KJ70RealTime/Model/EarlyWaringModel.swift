//
//  EarlyWaringModel.swift
//  ShineApp
//
//  Created by jiang.123 on 2020/4/6.
//  Copyright © 2020 jiang.123. All rights reserved.
//预警信息模型

import UIKit
@objcMembers
class EarlyWaringModel: NSObject {
    var MineCode : String = ""
    var SimpleName:String = ""
    var SensorNum : String = ""
    var Value : String = ""
    var Place : String = ""
    var BeginTime : String = ""
    
    init(dict : [String:Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}

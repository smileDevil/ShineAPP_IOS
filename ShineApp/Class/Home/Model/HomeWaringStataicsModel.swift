//
//  HomeWaringStataicsModel.swift
//  ShineApp
//
//  Created by jiang.123 on 2020/12/17.
//  Copyright © 2020 jiang.123. All rights reserved.
//

import UIKit
@objcMembers
class HomeWaringStataicsModel: NSObject {
    var 矿井超员 : String!
    var 矿井超时 : String!
    var 区域超时 : String!
    var 区域超员 : String!
    var 人员定位分站故障 : String!
    var 安全监控分站故障 : String!
    var 安全监控传感器故障 : String!
    var 超限 : String!
    var 断电 : String!
    
    init(dict : [String:Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}

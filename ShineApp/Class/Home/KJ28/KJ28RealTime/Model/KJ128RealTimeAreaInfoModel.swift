//
//  KJ128RealTimeAreaInfoModel.swift
//  ShineApp
//
//  Created by jiang.123 on 2020/4/24.
//  Copyright © 2020 jiang.123. All rights reserved.
//

import UIKit
@objcMembers
class KJ128RealTimeAreaInfoModel: NSObject {
    var TmpID : NSNumber!
    var SimpleName : String!
    var City : String!
    var AreaType : String!
    var AreaName : String!
    var Time : String!
    var Workers : NSNumber = 0
    var r : NSNumber!
    
    init(dict:[String : Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}

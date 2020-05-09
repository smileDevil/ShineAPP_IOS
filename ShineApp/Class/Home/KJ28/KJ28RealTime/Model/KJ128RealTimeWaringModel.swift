//
//  KJ128RealTimeWaringModel.swift
//  ShineApp
//
//  Created by jiang.123 on 2020/4/27.
//  Copyright © 2020 jiang.123. All rights reserved.
//

import UIKit
@objcMembers
class KJ128RealTimeWaringModel: NSObject {
    var TmpID : NSNumber!
    var Name : String!
    var SimpleName : String!
    var JobCardCode : String!
    var Position : String!
    var Department : String!
    var Place : String!
    var JobAddress : String!
    var InTime : String!
    var AreaName : String!
    var InAreaTime : String!
    var InNowStTime : String!
    var StartAlTime : String!
    var continuoustime : String!
    var `Type` : String!
    var r : NSNumber!
    
    init(dict:[String : Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}

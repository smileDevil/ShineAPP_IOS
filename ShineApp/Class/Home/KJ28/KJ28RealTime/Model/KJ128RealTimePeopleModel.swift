//
//  KJ128RealTimePeopleModel.swift
//  ShineApp
//
//  Created by jiang.123 on 2020/4/21.
//  Copyright © 2020 jiang.123. All rights reserved.
//

import UIKit
@objcMembers
class KJ128RealTimePeopleModel: NSObject {
    var TmpID : NSInteger = 0
    var MineCode : String!
    var SimpleName : String!
    var City : String!
    var JobCardCode : String!
    var continuoustime : String!
      var Name : String!
      var Position : String!
      var Department : String!
    var JobAddress : String!
      var InTime : String!
      var AreaName : String!
      var InAreaTime : String!
    var StationName : String!
      var Place : String!
      var InNowStTime : String!
    var r : Int = 0
    
    init(dict : [String:Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}

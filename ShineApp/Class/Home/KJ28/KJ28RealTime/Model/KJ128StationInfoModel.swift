//
//  KJ128StationInfoModel.swift
//  ShineApp
//
//  Created by jiang.123 on 2020/4/24.
//  Copyright © 2020 jiang.123. All rights reserved.
//

import UIKit
@objcMembers
class KJ128StationInfoModel: NSObject {
       var TmpID : NSNumber!
        var MineCode : String!
       var SimpleName : String!
       var City : String!
       var StationCode : String!
       var StationName : String!
    var Place : String!
    var State : String!
       var Time : String!
       var Counts : NSNumber!
       var r : NSNumber!
       
       init(dict:[String : Any]) {
           super.init()
           setValuesForKeys(dict)
       }
       
       override func setValue(_ value: Any?, forUndefinedKey key: String) {
           
       }
}

//
//  RealTimeOpenOutModel.swift
//  ShineApp
//
//  Created by jiang.123 on 2020/4/2.
//  Copyright © 2020 jiang.123. All rights reserved.
//

import UIKit
@objcMembers
class RealTimeOpenOutModel: NSObject {
    var TmpID : NSInteger = 0
          var SimpleName : String = ""
          var SensorNum : String = ""
          var TypeName : String = ""
          var Place : String = ""
          var state : String = ""
          var Datetime : String = ""
          var r : Int = 0
          init(dict:[String :Any]) {
              super.init()
              setValuesForKeys(dict)
          }
          
          override func setValue(_ value: Any?, forUndefinedKey key: String) {
              
          }
}

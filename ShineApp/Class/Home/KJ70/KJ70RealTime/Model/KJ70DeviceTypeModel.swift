//
//  KJ70DeviceTypeModel.swift
//  ShineApp
//
//  Created by jiang.123 on 2020/4/3.
//  Copyright © 2020 jiang.123. All rights reserved.
//

import UIKit
@objcMembers
class KJ70DeviceTypeModel: NSObject {
    var ID : String!
    var TypeCode : NSInteger = 0
    var Unit : String!
    var TypeName : String!
    var `Type` : String = ""
    
      init(dict : [String:Any]) {
          super.init()
          setValuesForKeys(dict)
      }
      
      override func setValue(_ value: Any?, forUndefinedKey key: String) {
          
      }
}

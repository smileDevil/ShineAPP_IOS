//
//  HomeWaringTypeModel.swift
//  ShineApp
//
//  Created by jiang.123 on 2020/12/18.
//  Copyright © 2020 jiang.123. All rights reserved.
//

import UIKit
@objcMembers
class HomeWaringTypeModel: NSObject {
        var typeName : String!
        var value : String!
       init(dict : [String:Any]) {
           super.init()
           setValuesForKeys(dict)
       }
       override func setValue(_ value: Any?, forUndefinedKey key: String) {
       }
}

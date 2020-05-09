//
//  PersonNameModel.swift
//  ShineApp
//
//  Created by jiang.123 on 2020/4/29.
//  Copyright © 2020 jiang.123. All rights reserved.
//

import UIKit


@objcMembers
class PersonNameModel: NSObject {
    
    var JobCardCode : String!
    var Name : String!
    var CardID : String!
    var Positon :String!
    var Department : String!
    
    init(dict:[String:Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}

//
//  NotificationModel.swift
//  ShineApp
//
//  Created by jiang.123 on 2020/12/19.
//  Copyright © 2020 jiang.123. All rights reserved.
//

import UIKit
@objcMembers
class NotificationModel: NSObject {
    var PushTitle : String!
    var PushContent : String!
    var PushState : String!
    var PushTime : String!
    
    init(dict : [String:Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
    }
}

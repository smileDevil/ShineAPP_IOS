//
//  KJ70SensorModel.swift
//  ShineApp
//
//  Created by jiang.123 on 2020/4/8.
//  Copyright © 2020 jiang.123. All rights reserved.
//

import UIKit
@objcMembers
class KJ70SensorModel: NSObject {
    
    var SensorNum : String = "" // 001D005
    var TypeName : String = "" // l开停
    var Place : String = "" // 皮带
    var ZeroMeaning : String = "" // 故障
    var OneMeaning : String = "" // 开
    var TwoMeaning : String = "" // 关
    init(dict : [String:Any]) {
           super.init()
           setValuesForKeys(dict)
       }
       
       override func setValue(_ value: Any?, forUndefinedKey key: String) {
           
       }
}

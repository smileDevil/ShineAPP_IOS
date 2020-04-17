//
//  RealTimeStationModel.swift
//  ShineApp
//
//  Created by jiang.123 on 2020/4/1.
//  Copyright © 2020 jiang.123. All rights reserved.
//

import UIKit
@objcMembers
class RealTimeStationModel: NSObject {
    var TmpID : NSInteger = 0
       var SimpleName : String = ""
       var MineCode : String = ""
       var SensorNum : String = ""
       var TypeName : String = ""
       var Unit : String = ""
       var Place : String = ""
       var ShowValue : String = ""
       var AlarmValueText : String = ""
       var OutPowerValueText : String = ""
       var InPowerValueText : String = ""
       var AlarmLower : String = ""
       var AlarmHigh : String = ""
       var OutPowerHigh : String = ""
       var OutPowerLower : String = ""
       var InPowerLower : String = ""
       var InPowerHigh : String = ""
       var ValueState : String = ""
       var Datetime : String = ""
       var continuoustime : String = ""
       var r : Int = 0
       
       init(dict:[String :Any]) {
           super.init()
           setValuesForKeys(dict)
       }
       
       override func setValue(_ value: Any?, forUndefinedKey key: String) {
           
       }
}

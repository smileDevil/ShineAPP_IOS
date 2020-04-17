//
//  RealTimeWaringModel.swift
//  ShineApp
//
//  Created by jiang.123 on 2020/3/26.
//  Copyright © 2020 jiang.123. All rights reserved.
//

import UIKit

@objcMembers
class RealTimeWaringModel: NSObject {
    var TmpID : NSInteger = 0
    var AlarmLevel : String = ""
    var DateTime : String = ""
    var SimpleName : String = ""
    var SensorNum : String = ""
    var TypeName : String = ""
    var Unit : String = ""
    var Place : String = ""
    var ShowValue : String = ""
    var AlarmValueText : String = ""
    var AlarmRemoveValueText : String = ""
    var AlarmLower : String = ""
    var AlarmHigh : String = ""
    var OutPowerHigh : String = ""
    var OutPowerLower : String = ""
    var InPowerLower : String = ""
    var InPowerHigh : String = ""
    var ValueState : String = ""
    var PoliceDatetime : String = ""
    var PoliceMaxValue : NSInteger = 0
    var PowerMaxDatetime : String = ""
    var powerMin : NSInteger = 0
    var PowerMinDatetime : String = ""
    var PowerAvg : NSInteger = 0
    var continuoustime : String = ""
    var r : Int = 0
    
    init(dict : [String:Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}

@objcMembers
class RealTimeWaringListModel: NSObject {
    var total : String = ""
    var rows : [[String:NSObject]]?{
        didSet {
                  guard let rows = rows else { return }
                  for dict in rows {
                      realTimeWaringModelList.append(RealTimeWaringModel(dict: dict))
                  }
              }
    }

    lazy var realTimeWaringModelList : [RealTimeWaringModel] = [RealTimeWaringModel]()
}

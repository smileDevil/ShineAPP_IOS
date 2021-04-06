//
//  KJ128HistoryDataModel.swift
//  ShineApp
//
//  Created by jiang.123 on 2020/5/13.
//  Copyright © 2020 jiang.123. All rights reserved.
//

import UIKit
@objcMembers
class KJ128HistoryDataModel: NSObject {
    var TmpID : NSNumber = 0
    var MineCode : String!
    var JobCardCode : String!
    var continuoustime : String!
    var JobAddress : String!
    var AreaName : String!

    var StationName : String!
    var StationCode : String!
    var Place : String!
    var StationState : NSNumber = 0
    var RingNetworkAddress : String!
    var RingNetworkState : String!
    var StartAlTime : String!
    var EndAlTime : String!
    var AlarmTime : String!
    var InNowStTime : String!
    var Duration : NSNumber = 0
    //人员历史超时报警
    var Name : String!
    var Position : String!
    var Department : String!
    var Profession : String!
    var AreaType : String!
    var InAreaTime : String!
    var OutAreaTime : String!

    // 历史人员超员及限制区域
    var `Type` : String!
    var Number : NSNumber!
    var Sum : NSNumber!
    var StationSum:NSNumber!
    //历史超员报警
    var SimpleName : String!
    var OvermanNum : String!
    var PeakValueTime : String!
    var OvermanRate : String!
    // 历史井下时间
    var InTime : String!
    var OutTime : String!
    
    //历史求救报警
    var Address : String!
    var StartHelpTime : String!
    var EndHelpTime : String!
    
    //历史考勤
    var InOutType : String!
    var Class : String!
    var WorkingHours : NSNumber!
    var WorkingDate : String!
    
    var r : Int = 0
    
    init(dict : [String:Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}

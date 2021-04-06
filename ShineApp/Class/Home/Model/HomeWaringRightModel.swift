//
//  HomeWaringRightModel.swift
//  ShineApp
//
//  Created by jiang.123 on 2020/12/18.
//  Copyright © 2020 jiang.123. All rights reserved.
//

import UIKit
@objcMembers
class HomeWaringRightModel: NSObject {
    //矿井超员
    var  InTime :String = ""
    var  OverTime :String = ""
    var  StartAlTime :String = ""
    var  Name :String = ""
    var  MaxWorkTime:String = ""
    var  Position :String = ""
    var  WorkTypeName :String = ""
    var  Department :String = ""
    var  JobCardCode :String = ""
    
    //区域超员
    var  AreaType :String = ""
    var  AreaName :String = ""
    var  CYNum :String = ""
    var  NowNum :String = ""
    var  limitNum :String = ""
    var  Time:String = ""
    
    //区域超时
    
    var  InAreaTime :String = ""
    var  WorkTime : NSInteger?
    
    //人员奋战故障
    var  StationCode :String = ""
    var  Place :String = ""
    var  StationName :String = ""
    var  StationState :NSInteger = 0
    
    //安全监控分站故障
    var  SensorNum :String = ""
    var  badchildren :NSInteger?
    var  StationTypeName:String = ""
    var  ValueState :NSInteger?
    
    //安全监控传感器故障
    
    var  SensorName :String = ""
    var  `Type` :NSInteger?
    var   Value :NSInteger?
    var   unit:String = ""
    
    
    
    init(dict : [String:Any]) {
          super.init()
          setValuesForKeys(dict)
      }
      
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
    
}

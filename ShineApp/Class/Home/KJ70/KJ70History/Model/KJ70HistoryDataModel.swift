//
//  KJ79HistoryDataModel.swift
//  ShineApp
//
//  Created by jiang.123 on 2020/4/9.
//  Copyright © 2020 jiang.123. All rights reserved.
//

import UIKit
@objcMembers
class KJ70HistoryDataModel: NSObject {

    //公共
      var  tmpID : NSNumber!//
      var  MineCode:NSNumber!//
      var  SimpleName:Any!//
      var  SensorNum:String!//
      var  TypeName:String!//
     var  Place:Any!//
      var  continuoustime:String!//持续时间
      var   Unit:String!//单位
      var   AlarmLevel:NSNumber!// 等级
      var   r:NSNumber!//
    
    var   `Type`:NSNumber!//201009
      //报警
      var   alarmtype:String!//报警类型"上限报警",
      var   PoliceDatetime:String!//报警开始时间
      var   PoliceEndDatetime:String!//报警结束时间
      var   AlarmValue:String!//报警值
      var   MaxValue:NSNumber!//最大值
      var   MaxTime:String!//最大值时间
      var   alarmwhy:String!//报警原因
      //断电
      var   PowerDatetime:String!//断电开始时间
      var   PowerEndDatetime:String!//断电结束时间
      var   max:NSNumber!//最大值
      var   mMaxTime:String!//最大值时间
      var   powertype:String!//断电类型
      var   powerwhy:String!//断电原因
      //故障
      var   RelevanceDepict:String!//"延长监控线",
      var   HitchDatetime:String!//开始时间
      var   HitchEndDatetime:String!//结束时间
      var   FaultCause:String!// 故障原因

      //模拟量
      var   StatisticaMaxValue:Any!//
      var   StatisticaMaxDatetime:String!//
      var   StatisticaMinValue:Any!//
      var   StatisticaMinDatetime:String!//
      var   StatisticaAvg:Any!//
      var   StatisticalTime:String!//
      // 开关量
      var   alarmstate:String!// "正常",
      var   powerstate:String!//"正常",
      var   State:String!//"正常",
      var   StateDatetime:String!//"正常",
      //历史预警 旧
      var   status:String!//201009
      var   starttime:String!// "正常",
      var   overtime:String!//"正常",
      var   ValueString:String!
      var   lasttime:String!//"正常",
      var  level:String!//"正常",
      var  fenxi:String!//"正常",
      var  chulway:String!//"正常",
      var  chulresult:String!//"正常"
      var  jlpers:String!//"正常",yanfa
      var  jltime:String!//"正常",
      var  Datetime:String!//"正常",
    //历史预警新
    var Value : NSNumber!
    var BeginTime:String!
    var EndTime:String!
    var MeasureMessage:String!
    
    
    init(dict : [String:Any]) {
        super.init()
         setValuesForKeys(dict)
        if dict["maxTime"] != nil {
            self.mMaxTime = dict["maxTime"] as? String
        }
     }
     
     override func setValue(_ value: Any?, forUndefinedKey key: String) {
         
     }
}

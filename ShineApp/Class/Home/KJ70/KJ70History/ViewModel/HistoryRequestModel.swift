//
//  HistoryRequestModel.swift
//  ShineApp
//
//  Created by jiang.123 on 2020/4/9.
//  Copyright © 2020 jiang.123. All rights reserved.
//

import UIKit

class HistoryRequestModel: NSObject {
    //设备状态
      var historyDataModels : [KJ70HistoryDataModel] = [KJ70HistoryDataModel]()
      var historyDataCount : NSInteger = 0
    //折线图数据
    var lineDataModels : [SimulatesCurveInfoModel] = [SimulatesCurveInfoModel]()
    
     var mUrl :String = ""
    var mPageSize = 50
    var mIndex = 0
    var mBeginTime = ""
    var mEndTime = ""
    var mTypeCode = ""
    var mSensornum = ""
    
    func requestHistoryData(url:String,beginTime:String,endTime:String ,index:Int,pageSize:Int, typeCode:String , sensornum:String, finishedCallBack:@escaping () -> ()){
        mUrl = url
        mBeginTime = beginTime
        mEndTime = endTime
        mTypeCode = typeCode
        mSensornum = sensornum
        mIndex = index
        mPageSize = pageSize
        //1:定义参数
        let mineCode = UserDefaults.standard.string(forKey: "mineCode") ?? ""
        let requestUrl = REQUESTURL + mUrl
        let parameters = ["Minecode":mineCode,"BeginTime":mBeginTime,"EndTime":mEndTime,"RowIndex":mIndex,"RowSize":mPageSize, "Typecode":mTypeCode,"Sensornums":mSensornum] as [String : Any]
        NetworkTools.requestData(type: .GET, url: requestUrl, paramenters: parameters) { (result) in
            guard let resultDic =  result as? [String : NSObject]else {
                return
            }
            guard let resultCount = resultDic["total"] as? NSInteger else {
                return
            }
            guard let resultArr = resultDic["rows"] as? [[String : NSObject]] else {
                return
            }
            self.historyDataCount = resultCount
            if resultArr.count != 0 {
                if self.mIndex == 0 {
                self.historyDataModels.removeAll()
                }
                for dic in resultArr {
                    let model : KJ70HistoryDataModel = KJ70HistoryDataModel.init(dict: dic)
                    self.historyDataModels.append(model)
                }
            }
            finishedCallBack()
        }
    }
    
    func GetKj70HisSimulatesCurveInfo(sensorNum:String,beginTime:String,endTime:String, finishedCallBack:@escaping () -> ()){
        
            let mineCode = UserDefaults.standard.string(forKey: "mineCode") ?? ""
              let requestUrl = REQUESTURL + "GetKj70HisSimulatesCurveInfo"
              let parameters = ["Minecode":mineCode,"BeginTime":beginTime,"EndTime":endTime,"Sensornums":sensorNum] as [String : Any]
              NetworkTools.requestData(type: .GET, url: requestUrl, paramenters: parameters) { (result) in
                  guard let resultDic =  result as? [String : NSObject]else {
                      return
                  }
                  guard let resultCount = resultDic["total"] as? NSInteger else {
                      return
                  }
                guard let resultArrBefor = resultDic["rows"] as? [[String : NSObject]] else {
                      return
                  }
                guard let resultArr = resultArrBefor[0] as? [[String : NSObject]] else {
                                     return
                                 }
                
                  if resultArr.count != 0 {
              
                      self.historyDataModels.removeAll()
                  
                      for dic in resultArr {
                      let model : SimulatesCurveInfoModel = SimulatesCurveInfoModel.init(dict: dic)
                      self.lineDataModels.append(model)
                      }
                  }
                  finishedCallBack()
              }
    }
}

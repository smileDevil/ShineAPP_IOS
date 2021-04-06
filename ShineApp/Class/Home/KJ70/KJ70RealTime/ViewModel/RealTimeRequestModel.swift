//
//  RealTimeRequestModel.swift
//  ShineApp
//
//  Created by jiang.123 on 2020/4/1.
//  Copyright © 2020 jiang.123. All rights reserved.
//

import UIKit

class RealTimeRequestModel: NSObject {
    //设备状态
     var realTimeEquipmentModels : [RealTimeEquipmentModel] = [RealTimeEquipmentModel]()
     var equipmentCount : NSInteger = 0
    //测点信息
     var realTimeTestPointModels : [RealTimeTestPointModel] = [RealTimeTestPointModel]()
     var testPointCount : NSInteger = 0
    //分站信息
     var realTimeStationModels : [RealTimeStationModel] = [RealTimeStationModel]()
     var stationCount : NSInteger = 0
    //开出口信息
     var realTimeOpenOutModels : [RealTimeOpenOutModel] = [RealTimeOpenOutModel]()
     var openoutCount : NSInteger = 0
    //实时预警信息
    var realTimeEarlyWaringModels : [EarlyWaringModel] = [EarlyWaringModel]()
    var earlyWaringCount : NSInteger = 0
    //设备类型
    
    
    
    lazy var deviceTypeList: [KJ70DeviceTypeModel] =  [KJ70DeviceTypeModel]()
    
    //获取煤矿的数量
      lazy var mineModelList : [MineModel] = [MineModel]()
}
extension RealTimeRequestModel{
    //实时设备故障
    func requestEquipmentData( finishedCallBack:@escaping () -> ()){
        //1:定义参数
        let mineCode = UserDefaults.standard.string(forKey: "mineCode") ?? ""
//        let requestUrl = REQUESTURL + "GetKj70RealTimeFaultInfo"
        var requestUrl = UserDefaults.standard.string(forKey: "httpUrl") ?? ""
               if requestUrl == "" {
                   requestUrl = REQUESTURL + "GetKj70RealTimeFaultInfo"
               }else{
                   requestUrl = requestUrl + "GetKj70RealTimeFaultInfo"
               }
        let parameters = ["Minecode":mineCode,"TypeCode":"","Sensornum":""]
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
            if resultCount != 0 {
                self.equipmentCount = resultCount
                self.realTimeEquipmentModels.removeAll()
                for dic in resultArr {
                    let model : RealTimeEquipmentModel = RealTimeEquipmentModel.init(dict: dic)
                    self.realTimeEquipmentModels.append(model)
                }
            }
            finishedCallBack()
        }
    }
    //测点信息
    func requestTestPointData( finishedCallBack:@escaping () -> ()){
        //1:定义参数
        let mineCode = UserDefaults.standard.string(forKey: "mineCode") ?? ""
//        let requestUrl = REQUESTURL + "GetKj70RealTimeSensorInfo"
        var requestUrl = UserDefaults.standard.string(forKey: "httpUrl") ?? ""
                      if requestUrl == "" {
                          requestUrl = REQUESTURL + "GetKj70RealTimeSensorInfo"
                      }else{
                          requestUrl = requestUrl + "GetKj70RealTimeSensorInfo"
                      }
        let parameters = ["Minecode":mineCode]
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
            if resultCount != 0 {
                self.testPointCount = resultCount
                self.realTimeTestPointModels.removeAll()
                for dic in resultArr {
                    let model : RealTimeTestPointModel = RealTimeTestPointModel.init(dict: dic)
                    self.realTimeTestPointModels.append(model)
                }
            }
            finishedCallBack()
        }
    }
    //实时分站信息
    func requestStationData( finishedCallBack:@escaping () -> ()){
        //1:定义参数
        let mineCode = UserDefaults.standard.string(forKey: "mineCode") ?? ""
//        let requestUrl = REQUESTURL + "GetKj70RealTimeStationInfo"
        var requestUrl = UserDefaults.standard.string(forKey: "httpUrl") ?? ""
                           if requestUrl == "" {
                               requestUrl = REQUESTURL + "GetKj70RealTimeStationInfo"
                           }else{
                               requestUrl = requestUrl + "GetKj70RealTimeStationInfo"
                           }
        let parameters = ["Minecode":mineCode]
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
            if resultCount != 0 {
                self.stationCount = resultCount
                self.realTimeStationModels.removeAll()
                for dic in resultArr {
                    let model : RealTimeStationModel = RealTimeStationModel.init(dict: dic)
                    self.realTimeStationModels.append(model)
                }
            }
            finishedCallBack()
        }
    }
    
    //实时开出口
       func requestOpenoutData( finishedCallBack:@escaping () -> ()){
           //1:定义参数
           let mineCode = UserDefaults.standard.string(forKey: "mineCode") ?? ""
//           let requestUrl = REQUESTURL + "GetKj70RTControlBreakInfo"
        var requestUrl = UserDefaults.standard.string(forKey: "httpUrl") ?? ""
                                  if requestUrl == "" {
                                      requestUrl = REQUESTURL + "GetKj70RTControlBreakInfo"
                                  }else{
                                      requestUrl = requestUrl + "GetKj70RTControlBreakInfo"
                                  }
           let parameters = ["Minecode":mineCode,"SensorNum":""]
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
               if resultCount != 0 {
                   self.openoutCount = resultCount
                   self.realTimeOpenOutModels.removeAll()
                   for dic in resultArr {
                       let model : RealTimeOpenOutModel = RealTimeOpenOutModel.init(dict: dic)
                       self.realTimeOpenOutModels.append(model)
                   }
               }
               finishedCallBack()
           }
       }
    
    //实时预警信息
    
          func requestEarlyWaringData( finishedCallBack:@escaping () -> ()){
              //1:定义参数
              let mineCode = UserDefaults.standard.string(forKey: "mineCode") ?? ""
//              let requestUrl = REQUESTURL + "GetKj70RealTimeWarnAlarmInfo"
            var requestUrl = UserDefaults.standard.string(forKey: "httpUrl") ?? ""
                                             if requestUrl == "" {
                                                 requestUrl = REQUESTURL + "GetKj70RealTimeWarnAlarmInfo"
                                             }else{
                                                 requestUrl = requestUrl + "GetKj70RealTimeWarnAlarmInfo"
                                             }
              let parameters = ["Minecode":mineCode,"TypeCode":"","Sensornum":""]
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
                  if resultCount != 0 {
                    self.earlyWaringCount = resultCount
                    self.realTimeEarlyWaringModels.removeAll()
                      for dic in resultArr {
                          let model : EarlyWaringModel = EarlyWaringModel.init(dict: dic)
                          self.realTimeEarlyWaringModels.append(model)
                      }
                  }
                  finishedCallBack()
              }
          }
    
    
    func getDeviceTypeList(finishedCallBack:@escaping () -> ()){
         //1:定义参数
         let mineCode = UserDefaults.standard.string(forKey: "mineCode") ?? ""
//         let requestUrl = REQUESTURL + "/GetKj70AllDeviceType"
        var requestUrl = UserDefaults.standard.string(forKey: "httpUrl") ?? ""
        if requestUrl == "" {
            requestUrl = REQUESTURL + "GetKj70AllDeviceType"
        }else{
            requestUrl = requestUrl + "GetKj70AllDeviceType"
        }
         let parameters = ["Minecode":mineCode]
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
             if resultCount != 0 {
                 self.deviceTypeList.removeAll()
                 for dic in resultArr {
                     let model : KJ70DeviceTypeModel = KJ70DeviceTypeModel.init(dict: dic)
                     self.deviceTypeList.append(model)
                 }
             }
             finishedCallBack()
         }
     }
    
    func getMineList(finishedCallBack:@escaping () -> ()){
            //1:定义参数
//            let requestUrl = REQUESTURL + "/GetOtherMineListInfo"
        var requestUrl = UserDefaults.standard.string(forKey: "httpUrl") ?? ""
               if requestUrl == "" {
                   requestUrl = REQUESTURL + "GetOtherMineListInfo"
               }else{
                   requestUrl = requestUrl + "GetOtherMineListInfo"
               }
            let parameters = ["Minecode":""]
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
                if resultCount != 0 {
                    self.mineModelList.removeAll()
                    for dic in resultArr {
                        let model : MineModel = MineModel.init(dict: dic)
                        self.mineModelList.append(model)
                    }
                }
                finishedCallBack()
            }
        }
}

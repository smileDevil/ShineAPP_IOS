//
//  Kj128RealTimeViewModel.swift
//  ShineApp
//
//  Created by jiang.123 on 2020/4/22.
//  Copyright © 2020 jiang.123. All rights reserved.
//

import UIKit

class Kj128RealTimeViewModel: NSObject {
    //设备状态
     var realTimePeopleModels : [KJ128RealTimePeopleModel] = [KJ128RealTimePeopleModel]()
     var peopleCount : NSInteger = 0
    // 区域信息
    var realTimeAreaInfoModels : [KJ128RealTimeAreaInfoModel] = [KJ128RealTimeAreaInfoModel]()
    var areaInfoCount : NSInteger = 0
    // 分站状态信息
       var realTimeStationStateModels : [KJ128StationInfoModel] = [KJ128StationInfoModel]()
       var stationCount : NSInteger = 0
}
extension Kj128RealTimeViewModel{
    //实时设备故障
       func request128RealTimePeopleData( finishedCallBack:@escaping () -> ()){
           //1:定义参数
           let mineCode = UserDefaults.standard.string(forKey: "mineCode") ?? ""
           let requestUrl = REQUESTURL + "GetKj128RealTimeInfo"
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
                   self.peopleCount = resultCount
                   self.realTimePeopleModels.removeAll()
                   for dic in resultArr {
                       let model : KJ128RealTimePeopleModel = KJ128RealTimePeopleModel.init(dict: dic)
                       self.realTimePeopleModels.append(model)
                   }
               }
               finishedCallBack()
           }
       }
    //获取区域信息
    func request128AreaInfo(finishedCallBack:@escaping () -> ()){
        let mineCode = UserDefaults.standard.string(forKey: "mineCode") ?? ""
        let requestUrl = REQUESTURL + "GetKj128AreaInfo"
        let parameters = ["Minecode" : mineCode,"AreaCode":""]
        NetworkTools.requestData(type: .GET, url: requestUrl,paramenters: parameters) { (result) in
            guard let resultDic = result as? [String : NSObject] else {
                return
            }
            guard let resultCount = resultDic["total"] as? NSInteger else {
                return
            }
            guard let resultArr = resultDic["rows"] as? [[String : NSObject]] else {
                return
            }
            if resultCount != 0 {
                self.areaInfoCount = resultCount
                self.realTimeAreaInfoModels.removeAll()
                for dic in resultArr {
                    let model : KJ128RealTimeAreaInfoModel = KJ128RealTimeAreaInfoModel(dict: dic)
                    self.realTimeAreaInfoModels.append(model)
                }
            }
            finishedCallBack()
            
        }
        
    }
    
    //获取分站状态
      func request128StationState(finishedCallBack:@escaping () -> ()){
          let mineCode = UserDefaults.standard.string(forKey: "mineCode") ?? ""
          let requestUrl = REQUESTURL + "GetKj128BaseSubStationInfo"
          let parameters = ["Minecode" : mineCode]
          NetworkTools.requestData(type: .GET, url: requestUrl,paramenters: parameters) { (result) in
              guard let resultDic = result as? [String : NSObject] else {
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
                  self.realTimeStationStateModels.removeAll()
                  for dic in resultArr {
                      let model : KJ128StationInfoModel = KJ128StationInfoModel(dict: dic)
                      self.realTimeStationStateModels.append(model)
                  }
              }
              finishedCallBack()
              
          }
          
      }
}

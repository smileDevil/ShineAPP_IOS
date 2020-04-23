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
}

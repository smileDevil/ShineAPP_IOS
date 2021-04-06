//
//  RealTimeWaringViewModel.swift
//  ShineApp
//
//  Created by jiang.123 on 2020/3/27.
//  Copyright © 2020 jiang.123. All rights reserved.
//

import UIKit

class RealTimeWaringViewModel: NSObject {

    fileprivate lazy var realTimeDataListModel : RealTimeWaringListModel = RealTimeWaringListModel()
    lazy var modelList : [RealTimeWaringModel] = [RealTimeWaringModel]()
    lazy var deviceTypeList: [KJ70DeviceTypeModel] =  [KJ70DeviceTypeModel]()
    lazy var sensorList: [KJ70SensorModel] =  [KJ70SensorModel]()
}

extension RealTimeWaringViewModel {
    func requestData(url:String ,typeName:String, finishedCallBack:@escaping () -> ()){
        //1:定义参数
        let mineCode = UserDefaults.standard.string(forKey: "mineCode") ?? ""
//        let requestUrl = REQUESTURL + url
        
        var requestUrl = UserDefaults.standard.string(forKey: "httpUrl") ?? ""
        if requestUrl == "" {
            requestUrl = REQUESTURL + url
        }else{
            requestUrl = requestUrl + url
        }
        
        let parameters = ["Minecode":mineCode,"TypeCode":"","TypeName":typeName,"Sensornum":"","AlarmLevel":"","Place":""]
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
            self.modelList.removeAll()
            if resultCount != 0 {
                for dic in resultArr {
                    let model : RealTimeWaringModel = RealTimeWaringModel.init(dict: dic)
                    self.modelList.append(model)
                }
            }
            finishedCallBack()
        }
    }
    
    func getDeviceTypeList(finishedCallBack:@escaping () -> ()){
        //1:定义参数
        let mineCode = UserDefaults.standard.string(forKey: "mineCode") ?? ""
//        let requestUrl = REQUESTURL + "/GetKj70AllDeviceType"
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
    
    func getSensorList(typeCode:Int , type:String, finishedCallBack:@escaping () -> ()){
           //1:定义参数
           let mineCode = UserDefaults.standard.string(forKey: "mineCode") ?? ""
//           let requestUrl = REQUESTURL + "/GetKj70SensorNumListInfo"
        var requestUrl = UserDefaults.standard.string(forKey: "httpUrl") ?? ""
                    if requestUrl == "" {
                        requestUrl = REQUESTURL + "GetKj70SensorNumListInfo"
                    }else{
                        requestUrl = requestUrl + "GetKj70SensorNumListInfo"
                    }
        
        let parameters = ["Minecode":mineCode,"Typecode":typeCode,"Type":type] as [String : Any]
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
                   self.sensorList.removeAll()
                   for dic in resultArr {
                       let model : KJ70SensorModel = KJ70SensorModel.init(dict: dic)
                       self.sensorList.append(model)
                   }
               }
               finishedCallBack()
           }
       }
    
}

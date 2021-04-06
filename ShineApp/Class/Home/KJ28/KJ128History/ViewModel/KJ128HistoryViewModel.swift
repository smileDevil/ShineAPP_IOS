//
//  KJ28HistoryViewModel.swift
//  ShineApp
//
//  Created by jiang.123 on 2020/4/29.
//  Copyright © 2020 jiang.123. All rights reserved.
//

import UIKit


class KJ128HistoryViewModel: NSObject {
            var peopleModels : [PersonNameModel] = [PersonNameModel]()
            var peopleCount : NSInteger = 0
    
    var historyDataModels:[KJ128HistoryDataModel] = [KJ128HistoryDataModel]()
    var historyDataCount : NSInteger = 0
    
      var mUrl :String = ""
      var mPageSize = 50
      var mIndex = 0
      var mBeginTime = ""
      var mEndTime = ""
    var mJobCardCode = ""
}

extension KJ128HistoryViewModel{
    //实时设备故障
       func getKJ128PersonLists( finishedCallBack:@escaping () -> ()){
           //1:定义参数
           let mineCode = UserDefaults.standard.string(forKey: "mineCode") ?? ""
//           let requestUrl = REQUESTURL + "GetKj128NameListInfo"
        var requestUrl = UserDefaults.standard.string(forKey: "httpUrl") ?? ""
                      if requestUrl == "" {
                          requestUrl = REQUESTURL + "GetKj128NameListInfo"
                      }else{
                          requestUrl = requestUrl + "GetKj128NameListInfo"
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
                   self.peopleCount = resultCount
                   self.peopleModels.removeAll()
                   for dic in resultArr {
                       let model : PersonNameModel = PersonNameModel.init(dict: dic)
                       self.peopleModels.append(model)
                   }
               }
               finishedCallBack()
           }
       }
    
    //实时设备故障
    func getKJ128HistoryDataLists( url:String ,beginTime:String,endTime:String,jobCardCode:String,index:Int,pageSize:Int, finishedCallBack:@escaping () -> ()){
        
        mUrl = url
        mBeginTime = beginTime
        mEndTime = endTime
        mJobCardCode = jobCardCode
        mIndex = index
        mPageSize = pageSize
        //1:定义参数
        let mineCode = UserDefaults.standard.string(forKey: "mineCode") ?? ""
//        let requestUrl = REQUESTURL + url
        var requestUrl = UserDefaults.standard.string(forKey: "httpUrl") ?? ""
                          if requestUrl == "" {
                              requestUrl = REQUESTURL + url
                          }else{
                              requestUrl = requestUrl + url
                          }
        var parameters = ["Minecode":mineCode] as [String : Any]
        if(mUrl == "GetKj128HisSubStation" || mUrl == "GetKj128HisOvermanReport"  ){
            parameters = ["Minecode" : mineCode,"RowIndex" : mIndex ,"RowSize" : mPageSize]
        }else if(mUrl == "GetKj128HisHelpAlarm"){
            parameters = ["Minecode" : mineCode,"RowIndex" : mIndex ,"RowSize" : mPageSize,"JobCardCode":mJobCardCode]
        }else if (mUrl == "GetKj128HisStation"){
            parameters = ["Minecode" : mineCode,"BeginTime":mBeginTime,"EndTime":mEndTime,"RowIndex" : mIndex ,"RowSize" : mPageSize,"StationCode":"","Name":""]
        }
        else{
            parameters = ["Minecode" : mineCode,"BeginTime":mBeginTime,"EndTime":mEndTime,"RowIndex" : mIndex ,"RowSize" : mPageSize,"JobCardCode":mJobCardCode]
        }
        
        
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
                self.historyDataCount = resultCount
                self.historyDataModels.removeAll()
                for dic in resultArr {
                    let model : KJ128HistoryDataModel = KJ128HistoryDataModel.init(dict: dic)
                    self.historyDataModels.append(model)
                }
            }
            finishedCallBack()
        }
    }
}

//
//  HomeWaringViewModel.swift
//  ShineApp
//
//  Created by jiang.123 on 2020/12/17.
//  Copyright © 2020 jiang.123. All rights reserved.
//

import UIKit

class HomeWaringViewModel: NSObject {
    
   public var mHomeWaringModel : HomeWaringStataicsModel?
    public var mHomeWaringRightList : [HomeWaringRightModel] = [HomeWaringRightModel]()
    
    //推送通知数据
    public var mNotificationList:[NotificationModel] = [NotificationModel]()
    public var notificationCount = 0
}

extension HomeWaringViewModel {
    func requestHomeWaringListData(finishedCallBack:@escaping () -> ()){
        //1:定义参数
        let mineCode = UserDefaults.standard.string(forKey: "mineCode") ?? ""
//        let requestUrl = REQUESTURL + "GetAppCurrentBriefInfo"
        var requestUrl = UserDefaults.standard.string(forKey: "httpUrl") ?? ""
              if requestUrl == "" {
                  requestUrl = REQUESTURL + "GetAppCurrentBriefInfo"
              }else{
                  requestUrl = requestUrl + "GetAppCurrentBriefInfo"
              }
        let parameters = ["Minecode":mineCode]
        NetworkTools.requestData(type: .GET, url: requestUrl, paramenters: parameters) { (result) in
            guard let resultDic =  result as? [String : NSObject]else {
                return
            }
            self.mHomeWaringModel = HomeWaringStataicsModel.init(dict: resultDic)
            finishedCallBack()
        }
    }
    
    func requestHomeWaringRightListData(typeName:String,finishedCallBack:@escaping () -> ()){
           //1:定义参数
           let mineCode = UserDefaults.standard.string(forKey: "mineCode") ?? ""
//           let requestUrl = REQUESTURL + "GetAppCurrentDetailInfo"
        var requestUrl = UserDefaults.standard.string(forKey: "httpUrl") ?? ""
                    if requestUrl == "" {
                        requestUrl = REQUESTURL + "GetAppCurrentDetailInfo"
                    }else{
                        requestUrl = requestUrl + "GetAppCurrentDetailInfo"
                    }
           let parameters = ["Minecode":mineCode,"alarmType":typeName]
           NetworkTools.requestData(type: .GET, url: requestUrl, paramenters: parameters) { (result) in
               guard let resultDicArr =  result as? [[String : NSObject]]else {
                   return
               }
            self.mHomeWaringRightList.removeAll()
            for dic in resultDicArr {
                let model : HomeWaringRightModel = HomeWaringRightModel.init(dict:dic)
                self.mHomeWaringRightList.append(model)
            }
               finishedCallBack()
           }
       }
       
    func requestMyNotificationData(startRow:Int,rowSize:Int,startTime:String,finishedCallBack:@escaping () -> ()){
             //1:定义参数
//             let requestUrl = REQUESTURL + "GetAppPushHistory"
        var requestUrl = UserDefaults.standard.string(forKey: "httpUrl") ?? ""
                          if requestUrl == "" {
                              requestUrl = REQUESTURL + "GetAppPushHistory"
                          }else{
                              requestUrl = requestUrl + "GetAppPushHistory"
                          }
        let parameters = ["startRow":startRow,"RowSize":rowSize,"startTime":startTime] as [String : Any]
             NetworkTools.requestData(type: .GET, url: requestUrl, paramenters: parameters) { (result) in
                
             guard let resultDic =  result as? [String : NSObject]else {
                     return
             }
                let total : Int = resultDic["total"] as? Int ?? 0
                self.notificationCount = total
                guard let resultDicArr = resultDic["rows"] as? [[String : NSObject]] else{
                    return
                }
              
              self.mNotificationList.removeAll()
              for dic in resultDicArr {
                  let model : NotificationModel = NotificationModel.init(dict:dic)
                  self.mNotificationList.append(model)
              }
                 finishedCallBack()
             }
         }
         
}

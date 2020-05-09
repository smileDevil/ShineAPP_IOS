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
}

extension KJ128HistoryViewModel{
    //实时设备故障
       func getKJ128PersonLists( finishedCallBack:@escaping () -> ()){
           //1:定义参数
           let mineCode = UserDefaults.standard.string(forKey: "mineCode") ?? ""
           let requestUrl = REQUESTURL + "GetKj128NameListInfo"
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
}

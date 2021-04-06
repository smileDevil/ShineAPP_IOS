//
//  LoginViewModel.swift
//  ShineApp
//
//  Created by jiang.123 on 2020/3/27.
//  Copyright © 2020 jiang.123. All rights reserved.
//

import UIKit

class LoginViewModel: NSObject {
    //MARK: 懒加载属性
    lazy var mineModelList : [MineModel] = [MineModel]()
    var registerReturnStr : String!
    var loginReturnStr = ""
    
}
extension LoginViewModel{
    
    func
        requestData(userName:String,psd:String, finishedCallBack:@escaping ()->()){
         // 1.定义参数
        let parameters = ["UserName":userName,"PassWord":psd]
        var url = UserDefaults.standard.string(forKey: "httpUrl") ?? ""
        if url == "" {
            url = REQUESTURL + "GetOtherLoginInfo"
        }else{
            url = url + "GetOtherLoginInfo"
        }
        NetworkTools.requestData(type: .GET, url: url, paramenters: parameters as [String : NSString]) { (result) in
            guard let resultDic =  result as? [String : NSObject]else {
                let returnstr = result as? String
                if returnstr != "" {
                    self.loginReturnStr = returnstr!
                }else{
                   self.loginReturnStr = "账号密码有误"
                }
                finishedCallBack()
                return
            }
            guard let resultArr = resultDic["rows"] as? [[String : NSObject]] else {
                return
            }
            for dic in resultArr {
                let mine : MineModel = MineModel.init(dict: dic)
                self.mineModelList.append(mine)
            }
            finishedCallBack()
        }
    }
    
    
    func registerRid(){
        let rid = UserDefaults.standard.string(forKey: "registId")
        let parameters = ["Rid":rid]
//        let url = REQUESTURL + "AppRegisterRid"
        var url = UserDefaults.standard.string(forKey: "httpUrl") ?? ""
              if url == "" {
                  url = REQUESTURL + "AppRegisterRid"
              }else{
                  url = url + "AppRegisterRid"
              }
        NetworkTools.requestData(type: .GET, url: url, paramenters: parameters) { (result) in
            let resultStr = result as? String
            print(resultStr)
        }
    }
    
     
    
    
    func requestStrData(userName:String,psd:String){
            // 1.定义参数
           let parameters = ["UserName":userName,"PassWord":psd]
           let url = REQUESTURL + "GetOtherLoginInfo"
           NetworkTools.requestStringData(type: .GET, url: url, paramenters: parameters as [String : NSString]) { (result) in
               
               guard let resultDic =  result as? [String : NSObject]else {
                   let returnstr = result as? String
                   self.loginReturnStr = returnstr ?? ""
                
                   return
               }
               
               guard let resultArr = resultDic["rows"] as? [[String : NSObject]] else {
                   return
               }
               
               for dic in resultArr {
                   var mine : MineModel = MineModel.init(dict: dic)
                   self.mineModelList.append(mine)
               }
           }
       }

    
    
    
    func registerUser(userName:String,psd:String ,finishedCallBack:@escaping () -> ()){
             let parameters = ["UserName":userName,"PassWord":psd]
               let url = REQUESTURL + "GetOtherAppRegister"
                    NetworkTools.requestStringData(type: .GET, url: url, paramenters: parameters as [String : NSString]) { (result) in
                   guard let resultStr =  result as? String else {
                       return
                   }
                   self.registerReturnStr = resultStr
        
                   finishedCallBack()
               }
    }
    
  
}

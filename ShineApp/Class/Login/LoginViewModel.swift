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
    
}
extension LoginViewModel{
    
    func requestData(userName:String,psd:String, finishedCallBack:@escaping ()->()){
         // 1.定义参数
        let parameters = ["UserName":userName,"PassWord":psd]
        let url = REQUESTURL + "GetOtherLoginInfo"
        NetworkTools.requestData(type: .GET, url: url, paramenters: parameters as [String : NSString]) { (result) in
            guard let resultDic =  result as? [String : NSObject]else {
                return
            }
            
            guard let resultArr = resultDic["rows"] as? [[String : NSObject]] else {
                return
            }
            
            for dic in resultArr {
                var mine : MineModel = MineModel.init(dict: dic)
                self.mineModelList.append(mine)
            }
            
            finishedCallBack()
        }
        
    }
}

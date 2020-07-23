//
//  NetworkTools.swift
//  DYZB
//
//  Created by jiang.123 on 2019/6/13.
//  Copyright © 2019年 jiang.123. All rights reserved.
//

import UIKit
import Alamofire

enum MethodType {
    case GET
    case POST
}

class NetworkTools {
    class func requestData(type:MethodType, url : String , paramenters: [String : Any]? = nil,finsihedCallBack : @escaping (_ result : AnyObject) -> ()) {
        //获取类型
        let method = type == .GET ? HTTPMethod.get : HTTPMethod.post
        //URLEncoding 请求get   JSONEncodiing 请求post
        
        Alamofire.request(url, method: method, parameters: paramenters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
             var theresult = response.result.value
            if theresult == nil {
                theresult = String(data:  response.data!, encoding: String.Encoding.utf8)
            }
            print(theresult)
            finsihedCallBack(theresult as AnyObject)
        }
    }
    
    
    class func requestStringData(type:MethodType, url : String , paramenters: [String : Any]? = nil,finsihedCallBack : @escaping (_ result : AnyObject) -> ()) {
          //获取类型
          let method = type == .GET ? HTTPMethod.get : HTTPMethod.post
          //URLEncoding 请求get   JSONEncodiing 请求post
          
        Alamofire.request(url, method: method, parameters: paramenters, encoding: URLEncoding.default, headers: nil).responseString(completionHandler: { (response) in
              guard let theresult = response.result.value else {
                  return
              }
              print(theresult)
              finsihedCallBack(theresult as AnyObject)
          })
      }
   
    class func responseData(type:MethodType, url : String , paramenters: [String : Any]? = nil,finsihedCallBack : @escaping (_ result : AnyObject) -> ()) {
             //获取类型
             let method = type == .GET ? HTTPMethod.get : HTTPMethod.post
             //URLEncoding 请求get   JSONEncodiing 请求post
             
           Alamofire.request(url, method: method, parameters: paramenters, encoding: URLEncoding.default, headers: nil).responseData(completionHandler: { (response) in
                 guard let theresultData = response.data else {
                     return
                 }
             let newStr = String(data: theresultData, encoding: String.Encoding.utf8)
               
                 finsihedCallBack(newStr as AnyObject)
             })
    }
        
    
    class func  singleRequest(url : String, finsihedCallBack : @escaping (_ resule : AnyObject) -> ()) {
        
        Alamofire.request(url).responseJSON { (response) in
            guard let theresult = response.result.value else {
                return
            }
            finsihedCallBack(theresult as AnyObject)
        }
        
    }
    
    //String 转字典
    class func strToDic(dataStr : String) -> [String: AnyObject] {
         let data = dataStr.data(using: String.Encoding.utf8)
         if let resultDic = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String : AnyObject] {
                     return resultDic
         }else {
             return [:]
         }
     }
}

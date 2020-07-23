//
//  Post.swift
//  ShineApp
//
//  Created by jiang.123 on 2020/3/12.
//  Copyright © 2020 jiang.123. All rights reserved.
//

import SwiftUI

//Model 数据模型
struct Post:Codable ,Identifiable{ //Codable 协议 可编码 可解码  // Identifiable 必须拥有id
    let id:Int
    let avatar:String // 头像
    let vip:Bool // 是否vip
    let name:String // 用户名
    let date:String //发布日期
    var isFollowed:Bool // 是否关注
    let text:String // 文本内容
    let images:[String]//内容图片
    var commentCount:Int
    var likeCount:Int
    var isLiked:Bool
}

extension Post {
    
    var avatarimage: Image{
        return loadImage(name: avatar)
    }
    
    var commonCountText : String {
        if commentCount <= 0 {
            return "评论"
        }
        if commentCount < 100 {return "\(commentCount)"}
        return String(format:"%.1fk", Double(commentCount)/1000)
        
    }
    var likeCountText:String{
        if likeCount <= 0 {
            return "点赞"
        }
        if likeCount <= 1000 {
            return "\(likeCount)"
        }
        return String(format: "%.1fK", Double(likeCount) / 1000)
    }
    
    
    
}


struct PostList:Codable {
    var list:[Post]
}

let postlist = loadPostListData(fileName: "PostListData_hot_1.json");


func loadPostListData(fileName:String) -> PostList{
    guard let url = Bundle.main.url(forResource: fileName, withExtension: nil) else {
        fatalError("无法找到文件名")
    }
    guard let data = try? Data(contentsOf: url) else{
        fatalError("没有数据")
    }
    
    guard let list = try? JSONDecoder().decode(PostList.self,from:data) else{
        fatalError("无法解析数据")
    }
    
    return list;
}
//添加加载图片方法
func loadImage(name:String) -> Image{
    return Image(uiImage:UIImage(named:name)!)
}


//struct PostList:Codable {
//    var list:[Post]
//}
//
////data model  //遵循 Identifiable协议, 并且有id的时候, 在postlistVIew中可以省略\.id
//struct Post:Codable , Identifiable{
//    //Property 属性
//    let id:Int
//    let avatar:String // 头像
//    let vip:Bool // 是否vip
//    let name:String
//    let date:String
//    var isFollowed:Bool
//
//    let text:String
//    let images:[String]
//
//    var commentCount:Int
//    var likeCount:Int
//    var isLiked:Bool
//}
////扩展
//extension Post {
//      var commentCountText:String{
//          if commentCount <= 0 {
//              return "评论"
//          }
//          if commentCount < 1000{
//              return "\(commentCount)"
//          }
//          return String(format: "%.1fK", Double(commentCount) / 1000)
//      }
//
//      var likeCountText:String{
//          if likeCount <= 0 {
//              return "点赞"
//          }
//          if likeCount <= 1000 {
//              return "\(likeCount)"
//          }
//          return String(format: "%.1fK", Double(likeCount) / 1000)
//      }
//}
//
//let postlist = loadPostListData(fileName: "PostListData_recommend_1.json");
//
//
//func loadPostListData(fileName:String) -> PostList{
//    guard let url = Bundle.main.url(forResource: fileName, withExtension: nil) else {
//        fatalError("无法找到文件名")
//    }
//    guard let data = try? Data(contentsOf: url) else{
//        fatalError("没有数据")
//    }
//
//    guard let list = try? JSONDecoder().decode(PostList.self,from:data) else{
//        fatalError("无法解析数据")
//    }
//
//    return list;
//}
//
//func loadImage(name:String) -> Image{
//    return Image(uiImage:UIImage(named:name)!)
//}

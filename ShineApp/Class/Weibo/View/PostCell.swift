//
//  PostCell.swift
//  ShineApp
//
//  Created by jiang.123 on 2020/3/12.
//  Copyright © 2020 jiang.123. All rights reserved.
//

import SwiftUI

struct PostCell: View {
    let post:Post
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10){
            HStack(){
                Image(uiImage: UIImage(named: post.avatar)!)
                    .resizable()//i可缩放
                    .scaledToFit()//保持宽高比缩放
                    .frame(width:50,height:50)
                    .clipShape(Circle())//图片裁成圆形
                    .overlay(
                        
                        VipBadge(vip: post.vip).offset(x:16,y:16)
                )
                
                
                VStack(alignment: .leading, spacing: 5){
                    Text(post.name).font(Font.system(size: 16))
                        .foregroundColor(Color(UIColor(r: 242, g: 99, b: 4)))
                        .lineLimit(1)
                    
                    Text(post.date).font(Font.system(size: 16))
                        .foregroundColor(.gray)
                }.padding(.leading,5)
                
                
                if(!post.isFollowed){
                    Spacer()//占位空间
                    
                    Button(action: {
                        print("click follow button")
                    }) {
                        Text("关注").font(Font.system(size: 14)).foregroundColor(.orange)
                            .frame(width: 50, height: 26)
                            .overlay(RoundedRectangle(cornerRadius: 13).stroke(Color.orange,lineWidth: CGFloat(1)))
                    }.buttonStyle(BorderlessButtonStyle())
                }
                
            }
            
            Text(post.text).font(.system(size:17))
            
            if !post.images.isEmpty {
//                Image(uiImage:UIImage(named:post.images[0])!).resizable().scaledToFill().frame(width:(UIScreen.main.bounds.width-30),height:(UIScreen.main.bounds.width-30)*0.75).clipped()
                PostImageCell(images: post.images, cellwidth: UIScreen.main.bounds.size.width-30)
            }
            
            Divider()
            
            HStack(spacing:0){
                Spacer()
                PostCellToolbarButton(image: "message", text: post.commentCountText, color: .black) {
                    print("click comment button")
                }
                 Spacer()
                PostCellToolbarButton(image: "heart", text: post.likeCountText, color: .red) {
                     print("click like button")
                }
                 Spacer()
            }
            
            Rectangle().frame(height:10)
            .foregroundColor(Color(red: 233/255, green: 233/255, blue: 233/255))
            
        }.padding(.top,16).padding(.horizontal,15)
        
        
        
    }
}

struct PostCell_Previews: PreviewProvider {
    static var previews: some View {
        PostCell(post: postlist.list[2])
    }
}

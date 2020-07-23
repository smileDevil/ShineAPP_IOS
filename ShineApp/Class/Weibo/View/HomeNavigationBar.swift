//
//  HomeNavigationBar.swift
//  ShineApp
//
//  Created by jiang.123 on 2020/3/17.
//  Copyright © 2020 jiang.123. All rights reserved.
//

import SwiftUI

private let kLabelWidth:CGFloat = 60
private let kButtonHeight:CGFloat = 24

struct HomeNavigationBar: View {
   @State var leftPercent:CGFloat//当为0 时下划线在左边  1 在右边
    var body: some View {
        HStack(alignment: .top, spacing: 0){
            Image(systemName: "camera").resizable().scaledToFit().frame(width: kButtonHeight, height: kButtonHeight).padding(.top,5).foregroundColor(.black)
            Spacer()
            VStack(spacing:3){
                HStack(spacing:0){
                    Text("推荐").bold().frame(width:kLabelWidth,height:kButtonHeight)
                        .padding(.top,5)
                        .opacity(Double(1 - leftPercent * 0.5)) // 设置透明度
                        .font(.system(size: 20)).onTapGesture {
                        withAnimation{
                            self.leftPercent = 0
                        }
                    }
                    Spacer()
                Text("热门").bold().frame(width:kLabelWidth,height:kButtonHeight)
                        .padding(.top,5)
                        .opacity(Double(0.5 + leftPercent * 0.5))
                        .onTapGesture {
                        //一句话添加动画
                        withAnimation{
                             self.leftPercent = 1
                        }
                       
                    }
                }.font(.system(size: 20))
                
                //几何读取器 和spacer 一样, 尽可能占位
                GeometryReader{geometry in
                    //下划线
                    RoundedRectangle(cornerRadius: 2).foregroundColor(.orange)
                        .frame(width:40,height:4)
                        .offset(x: (geometry.size.width  * (self.leftPercent - 0.5) + kLabelWidth * (0.5 - self.leftPercent )))
                }.frame(height:6)
                
                
            }.frame(width:UIScreen.main.bounds.width * 0.5)
            Spacer()
            Button(action: {
                
            }) {
                Image(systemName: "plus.circle.fill").resizable().scaledToFit().frame(width: kButtonHeight, height: kButtonHeight).padding(.top,5).foregroundColor(.orange)
            }
            }.padding(.horizontal,10).frame(width: mScreenW)
    }
}

struct HomeNavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        HomeNavigationBar(leftPercent: 0)
    }
}


//HStack(alignment: .top, spacing: 0){
//           //左侧按钮
//           Button(action: {
//
//           }) {
//               Image(systemName: "camera").resizable().scaledToFit().frame(width:kButtonHeight,height:kButtonHeight)
//                   .padding(.top,5)
//                   .padding(.horizontal,15).foregroundColor(.black)
//           }
//           Spacer()
//
//           VStack(spacing:3){
//               HStack(spacing:0){
//                          Text("推荐").bold().frame(width:kLabelWidth,height:kButtonHeight).padding(.top,5)
//                              Spacer()
//                          Text("热门").bold().frame(width:kLabelWidth,height:kButtonHeight).padding(.top,5)
//                      }.font(.system(size: 20))
//
//               GeometryReader{ geometry in
//                   RoundedRectangle(cornerRadius: 2).foregroundColor(.orange)
//                                  .frame(width:kLabelWidth,height:4)
//                       .offset(x:(geometry.size.width )*(self.leftPercent - 0.5) + kLabelWidth * (0.5 - self.leftPercent))
//               }.frame(height:6)
//
//           }.frame(width:UIScreen.main.bounds.width * 0.5)
//
//           Spacer()
//           // 右侧按钮
//           Button(action: {
//
//                      }) {
//                          Image(systemName: "plus.circle.fill").resizable().scaledToFit().frame(width:kButtonHeight,height:kButtonHeight)
//                              .padding(.top,5)
//                              .padding(.horizontal,15).foregroundColor(.orange)
//                      }
//       }

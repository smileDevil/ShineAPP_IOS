//
//  HomeView.swift
//  ShineApp
//
//  Created by jiang.123 on 2020/5/15.
//  Copyright © 2020 jiang.123. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    init() {
        UITableViewCell.appearance().selectionStyle = .none
                 //点击没有灰色
    }
    
    var body: some View {
        NavigationView{
            GeometryReader{ geometry in
                HScrollViewController(pageWidth: mScreenW, contentSize: CGSize(width: mScreenW * 2, height: geometry.size.height)) {
                    HStack(spacing:0){
                                       PostListView(category: PostListCategory.recommend)
                                       .frame(width:mScreenW)
                                       
                                       PostListView(category: PostListCategory.hot)
                                       .frame(width:mScreenW)
                                   }
                }
            }
//            ScrollView(.horizontal, showsIndicators: false) {
//                HStack(spacing:0){
//                    PostListView(category: PostListCategory.recommend)
//                    .frame(width:mScreenW)
//
//                    PostListView(category: PostListCategory.hot)
//                    .frame(width:mScreenW)
//                }
//                }
                .edgesIgnoringSafeArea(.bottom)//边界忽略安全区域
            .navigationBarItems(leading: HomeNavigationBar(leftPercent: 0))
                                     .navigationBarTitle("首页",displayMode: .inline)
//
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

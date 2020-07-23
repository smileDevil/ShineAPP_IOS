//
//  PostListView.swift
//  ShineApp
//
//  Created by jiang.123 on 2020/3/14.
//  Copyright © 2020 jiang.123. All rights reserved.
//

import SwiftUI

struct PostListView: View {
    let category : PostListCategory
    var postlist : PostList {
        switch category {
        case .recommend:
            return loadPostListData(fileName: "PostListData_recommend_1.json")
        case .hot :  return loadPostListData(fileName: "PostListData_hot_1.json")
           
        }
    }
    
   
    var body: some View {
        List{
            
            ForEach( self.postlist.list){ post in
                ZStack{
                       PostCell(post:post)
                    NavigationLink(destination: PostDetailView(post: post)) {
                        EmptyView()
                    }.hidden()
                }.listRowInsets(EdgeInsets())

            }
        }
      
    }
}

struct PostListView_Previews: PreviewProvider {
    static var previews: some View {
        PostListView(category: .recommend)
    }
}

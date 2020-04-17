//
//  PostListView.swift
//  ShineApp
//
//  Created by jiang.123 on 2020/3/14.
//  Copyright © 2020 jiang.123. All rights reserved.
//

import SwiftUI

struct PostListView: View {
    init() {
        UITableViewCell.appearance().selectionStyle = .none
    }
    var body: some View {
        List{
            ForEach(postlist.list,id: \.id){ post in
                ZStack{
                    PostCell(post:post)
                    NavigationLink(destination: PostDetailView(post: post)) {
                          EmptyView()
                    }.hidden()
                }
                
                .listRowInsets(EdgeInsets())
                  }
        }
        
      
    }
}

struct PostListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
           PostListView()
            .navigationBarTitle("title",displayMode: .inline)
        }
        
    }
}

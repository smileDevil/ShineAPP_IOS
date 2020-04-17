//
//  PostDetailView.swift
//  ShineApp
//
//  Created by jiang.123 on 2020/3/17.
//  Copyright © 2020 jiang.123. All rights reserved.
//

import SwiftUI

struct PostDetailView: View {
    let post:Post
    var body: some View {
        List{
            PostCell(post: post).listRowInsets(EdgeInsets())
            
            ForEach(1...10,id: \.self){ i in
                Text("评论\(i)")
            }
        }
    .navigationBarTitle("详情")
    }
}

struct PostDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PostDetailView(post: postlist.list[0])
    }
}

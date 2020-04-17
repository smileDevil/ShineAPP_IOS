//
//  VipBadge.swift
//  ShineApp
//
//  Created by jiang.123 on 2020/3/12.
//  Copyright © 2020 jiang.123. All rights reserved.
//

import SwiftUI

struct VipBadge: View {
    let vip:Bool
    var body: some View {
        Group{
            if vip {
                       Text("V").bold().font(.system(size: 11)).frame(width:15,height:15).foregroundColor(.yellow).background(Color.red).clipShape(Circle())
                           .overlay(
                               RoundedRectangle(cornerRadius: 7.5).stroke(Color.white, lineWidth: 1)
                       )
                   }
        }
    }
}

struct VipBadge_Previews: PreviewProvider {
    static var previews: some View {
        VipBadge(vip:true)
    }
}

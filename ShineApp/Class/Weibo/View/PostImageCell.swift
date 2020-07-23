//
//  PostImageCell.swift
//  ShineApp
//
//  Created by jiang.123 on 2020/3/17.
//  Copyright © 2020 jiang.123. All rights reserved.
//

import SwiftUI

private let kImageSpace: CGFloat = 6

struct PostImageCell: View {
    let images : [String]
    let cellwidth : CGFloat
    
    var body: some View {
        Group{
            
            if images.count == 1 {
                loadImage(name: images[0]).resizable().scaledToFill().frame(width:cellwidth - 30,height: (cellwidth - 30 ) * 0.75).clipped()
            } else if images.count == 2{
                PostImageCellRow(images: images, width: cellwidth)
            }else if images.count == 3{
                PostImageCellRow(images: images, width: cellwidth)
            }else if images.count == 4{
                VStack(spacing:kImageSpace){
                    PostImageCellRow(images: Array(images[0...1]), width: cellwidth)
                    PostImageCellRow(images: Array(images[2...3]), width: cellwidth)
                    
                    
                }
            }else if images.count == 5{
                VStack(spacing:kImageSpace){
                    PostImageCellRow(images: Array(images[0...1]), width: cellwidth)
                    PostImageCellRow(images: Array(images[2...4]), width: cellwidth)
                }
                
            }else if images.count == 6{
                VStack(spacing:kImageSpace){
                    PostImageCellRow(images: Array(images[0...2]), width: cellwidth)
                    PostImageCellRow(images: Array(images[3...5]), width: cellwidth)
                    
                }
            }
                
        }
    }
}
    
    struct PostImageCellRow : View {
        let images: [String]
        let width:CGFloat
        var body : some View {
            
            HStack(spacing:kImageSpace) {
                ForEach(images,id:\.self){image in
                    loadImage(name: image).resizable().scaledToFill().frame(width:(self.width - kImageSpace*CGFloat((self.images.count-1)))/CGFloat(self.images.count),height:(self.width - kImageSpace*CGFloat((self.images.count-1)))/CGFloat(self.images.count)).clipped()
                }
            }
        }
    }
    
    struct PostImageCell_Previews: PreviewProvider {
        static var previews: some View {
            return PostImageCell(images: postlist.list[4].images,cellwidth: mScreenW - 30)
//            return Group {
//                PostImageCell(images: postlist.list[0].images,cellwidth: mScreenW - 30)
//                PostImageCell(images: postlist.list[1].images,cellwidth: mScreenW - 30)
//                PostImageCell(images: postlist.list[2].images,cellwidth: mScreenW - 30)
//                PostImageCell(images: postlist.list[3].images,cellwidth: mScreenW - 30)
//                PostImageCell(images: postlist.list[4].images,cellwidth: mScreenW - 30)
//                PostImageCell(images: postlist.list[5].images,cellwidth: mScreenW - 30)
//            }.previewLayout(.fixed(width: mScreenW, height: 300))
        }
        
}
//struct PostImageCell: View {
//    let images : [String]
//    let cellwidth : CGFloat
//
//    var body: some View {
//        Group{
//            if images.count == 1 { Image(uiImage:UIImage(named:images[0])!).resizable().scaledToFill().frame(width:(cellwidth - 30),height:(cellwidth - 30)*0.75).clipped()
//
//                   }else if images.count == 2{
//                       PostImageCellRow(images: images, width: cellwidth)
//                   }else if images.count == 3{
//                        PostImageCellRow(images: images, width: cellwidth)
//                   }else if images.count == 4{
//                    VStack(spacing:kImageSpace){
//                        PostImageCellRow(images: Array(images[0...1]), width: cellwidth)
//                        PostImageCellRow(images: Array(images[2...3]), width: cellwidth)
//
//
//                    }
//                   }else if images.count == 5{
//                    VStack(spacing:kImageSpace){
//                        PostImageCellRow(images: Array(images[0...1]), width: cellwidth)
//                        PostImageCellRow(images: Array(images[2...4]), width: cellwidth)
//                                       }
//
//                   }else if images.count == 6{
//                       VStack(spacing:kImageSpace){
//                       PostImageCellRow(images: Array(images[0...2]), width: cellwidth)
//                        PostImageCellRow(images: Array(images[3...5]), width: cellwidth)
//
//                }
//                   }
//        }
//    }
//}
//
//struct PostImageCellRow:View {
//    let images: [String]
//    let width:CGFloat
//    var body: some View{
//        HStack(spacing:kImageSpace){
//            ForEach(images,id: \.self){image in Image(uiImage:UIImage(named:image)!).resizable().scaledToFill().frame(width:(self.width - kImageSpace*CGFloat((self.images.count-1)))/CGFloat(self.images.count),height:(self.width - kImageSpace*CGFloat((self.images.count-1)))/CGFloat(self.images.count)).clipped()
//            }
//        }
//    }
//}
//
//
//struct PostImageCell_Previews: PreviewProvider {
//    static var previews: some View {
//        let width = UIScreen.main.bounds.width
//        let images = postlist.list[5].images
////        return  PostImageCell(images: postlist.list[5].images, cellwidth: width - 30)
//        return Group{  // 通过group 同时预览不懂情况
//            PostImageCell(images: Array(images[0...0]), cellwidth: width - 30)
//            PostImageCell(images: Array(images[0...1]), cellwidth: width - 30)
//            PostImageCell(images: Array(images[0...2]), cellwidth: width - 30)
//            PostImageCell(images: Array(images[0...3]), cellwidth: width - 30)
//            PostImageCell(images: Array(images[0...4]), cellwidth: width - 30)
//            PostImageCell(images: Array(images[0...5]), cellwidth: width - 30)
//        }.previewLayout(.fixed(width: width, height: 300))
//    }
//}

//
//  HScrollViewController.swift
//  ShineApp
//
//  Created by jiang.123 on 2020/5/15.
//  Copyright © 2020 jiang.123. All rights reserved.
//

import SwiftUI

struct HScrollViewController<Content:View>: UIViewControllerRepresentable{
    let pageWidth : CGFloat
    let contentSize : CGSize
    let content: Content
    @State var leftPerent : CGFloat = 0
    
    init(pageWidth:CGFloat,contentSize:CGSize,@ViewBuilder content:() -> Content){
        self.pageWidth = pageWidth
        self.contentSize = contentSize
        self.content = content()
    }
    //这个方法是设置coordinator的,不设置的话 scrollview.delegate = context.coordinator会报错
    func makeCoordinator() -> HScrollViewController<Content>.Coordinator {
          return Coordinator(parent: self)
      }

    func makeUIViewController(context: Context) -> UIViewController {
        let scrollview = UIScrollView()
        scrollview.bounces = false
        scrollview.isPagingEnabled = true
        scrollview.showsVerticalScrollIndicator = false
        scrollview.showsHorizontalScrollIndicator = false
        scrollview.delegate = context.coordinator
        context.coordinator.scrollview = scrollview
        let vc = UIViewController()
        vc.view.addSubview(scrollview)
        
        let host = UIHostingController(rootView: content)
        vc.addChild(host)
        scrollview.addSubview(host.view)
        host.didMove(toParent: vc)
        context.coordinator.host = host
        return vc
        
    }
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        let scrollview = context.coordinator.scrollview!
        scrollview.frame = CGRect(x: 0, y: 0, width: pageWidth, height: contentSize.height)
        scrollview.contentSize = contentSize
        scrollview.setContentOffset(CGPoint(x: leftPerent * (contentSize.width - pageWidth), y: 0), animated: true)
        
        context.coordinator.host.view.frame = CGRect(origin: .zero, size: contentSize)
    }
   
    class Coordinator : NSObject , UIScrollViewDelegate{
        let parent : HScrollViewController
        var scrollview : UIScrollView!
        var host : UIHostingController<Content>!
        
        init(parent : HScrollViewController) {
            self.parent = parent
        }
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            print("EndDecelerating")
        }
    }
//    func makeUIViewController(context: UIViewControllerRepresentableContext<HScrollViewController<Content>>) -> HScrollViewController<Content>.UIViewControllerType {
//
//    }
}



//
//  MyNavigationController.swift
//  DYZB
//
//  Created by jiang.123 on 2019/6/6.
//  Copyright © 2019年 jiang.123. All rights reserved.
//

import UIKit

class MyNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.isNavigationBarHidden = false; //上部导航栏
        self.isToolbarHidden = true ;// 底部状态栏
        
        self.navigationBar.setBackgroundImage(UIImage(named: "nav_bg")?.resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode:  UIImage.ResizingMode.stretch), for: .default)
        
        
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white,NSAttributedString.Key.font:UIFont.systemFont(ofSize: 16)]
        
        
        self.navigationBar.frame = CGRect(x: 0, y: 0, width: JYBWindowWidth, height: navigationBarHeight)

    }
    
    //返回按钮
   @objc func backToPrevious(){
    self.popViewController(animated: true)
    }
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back_arrow.png")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(backToPrevious))
        }
        //设置成不可滑动
        self.interactivePopGestureRecognizer?.isEnabled = false
        super.pushViewController(viewController, animated: true)
    }
    
     //有背景颜色时,设置h状态栏白色
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

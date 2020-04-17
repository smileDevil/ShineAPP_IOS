//
//  RootTabBarViewController.swift
//  DYZB
//
//  Created by jiang.123 on 2019/6/6.
//  Copyright © 2019年 jiang.123. All rights reserved.
//

import UIKit
import Foundation

class RootTabBarViewController: UITabBarController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        

       // self.tabBar.tintColor = tabbarItemNormalColor;
//        self.tabBar.backgroundImage = UIImage(named: "nav_bg")?.resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode:  UIImage.ResizingMode.stretch)
//
        self.tabBar.isTranslucent = false  //避免受默认的半透明色影响，关闭
        self.tabBar.barTintColor = cellBgColor
        self.creatSubViewControllers()
        
        // Do any additional setup after loading the view.
    }
    func creatSubViewControllers(){
        addChildCOntroller(ChildController:HomeController(), Title: "首页", DefaultImage: UIImage(named: "home_blue")!, SelectedImage: UIImage(named: "home_blue_selected")!)
        
          addChildCOntroller(ChildController: OnePageController(), Title: "一张图", DefaultImage: UIImage(named: "onepage_blue")!, SelectedImage: UIImage(named: "onepage_blue_selected")!)

         addChildCOntroller(ChildController: LiveController(), Title: "监测", DefaultImage: UIImage(named: "system_blue")!, SelectedImage: UIImage(named: "system_blue_selected")!)

        addChildCOntroller(ChildController: MineController(), Title: "我的", DefaultImage: UIImage(named: "mine_blue")!, SelectedImage: UIImage(named: "mine_blue_selected")!)
    }
    

    
    func addChildCOntroller(ChildController child:UIViewController ,Title title:String ,DefaultImage defalutImage:UIImage, SelectedImage selectImage:UIImage){
        
        child.tabBarItem = UITabBarItem(title: title, image: defalutImage.withRenderingMode(.alwaysOriginal), selectedImage: selectImage.withRenderingMode(.alwaysOriginal))
//
//        if #available(iOS 13.0, *) {
//        let appearance = UITabBarAppearance()
//        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor:tabBarItemSelectdColor];
//        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor:tabBarItemSelectdColor]
//        child.tabBarItem.standardAppearance = appearance;
//    }else{
         child.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:tabBarItemSelectdColor], for: .selected);
//         child.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:tabbarItemNormalColor], for:UIControl.State.normal);
//        }
      
        
        let nav = MyNavigationController(rootViewController: child)
        //nav.navigationBar.barTintColor = UIColor.blue
       // nav.setNavigationBarHidden(false, animated: true)
//         nav.navigationBar.setBackgroundImage(UIImage(named: "nav_bg"), for: UIBarMetrics.default)
//        nav.navigationBar.barStyle = .default
        self.addChild(nav)
    }
    
    //改变系统tabBar高度
    override func viewDidLayoutSubviews() {
          super.viewDidLayoutSubviews()
      //确保代码执行一次
        DispatchQueue.once {
//              self.tabBar.frame = CGRect(x: self.tabBar.frame.origin.x, y: self.view.frame.size.height - tabBarHeight, width: self.tabBar.frame.size.width, height: tabBarHeight)
        }
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

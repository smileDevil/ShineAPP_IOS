//
//  BaseViewController.swift
//  ShineApp
//
//  Created by jiang.123 on 2020/3/20.
//  Copyright © 2020 jiang.123. All rights reserved.
//

import UIKit

class BaseViewController : UIViewController ,UIGestureRecognizerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad();
        self.view.backgroundColor = mainColor
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyBoard))
        tap.delegate = self
        self.view.addGestureRecognizer(tap)
        self.view.isUserInteractionEnabled = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(jpush(noti:)), name: NSNotification.Name(rawValue: "jpush"), object: nil)
    }
    @objc func dismissKeyBoard(){
        self.view.endEditing(true)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if NSStringFromClass((touch.view?.classForCoder)!) == "UITableViewCellContentView"{
            return false
        }else{
            return true
        }
    }
    
    @objc func jpush(noti: Notification) {
      let jpushViewController = MyNavigationController(rootViewController: NotificationViewController())
      self.present(jpushViewController, animated: true, completion: nil)
    }
    
    
}

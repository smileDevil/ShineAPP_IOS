//
//  AlertHepler.swift
//  ShineApp
//
//  Created by jiang.123 on 2020/3/30.
//  Copyright © 2020 jiang.123. All rights reserved.
//

import UIKit

class AlertHepler: NSObject {
    static func showAlert(titleStr: String?, msgStr: String?, style: UIAlertController.Style = .alert, currentVC: UIViewController, cancelBtn: String = "取消", cancelHandler:((UIAlertAction) -> Void)?, otherBtns:Array<String>?, otherHandler:((Int) -> ())?) {
        //DispatchQueue.global().async{}//子线程
        DispatchQueue.main.async { // 主线程执行
            let alertController = UIAlertController(title: titleStr, message: msgStr,preferredStyle: style)
            //取消按钮
            let cancelAction = UIAlertAction(title:cancelBtn, style: .cancel, handler:{ (action) -> Void in
                cancelHandler?(action)
            })
            alertController.addAction(cancelAction)
            //其他按钮
            if otherBtns != nil {
                for (index, value) in (otherBtns?.enumerated())! {
                    let otherAction = UIAlertAction(title: value, style: .default, handler: { (action) in
                        otherHandler!(index)
                    })
                    alertController.addAction(otherAction)
                }
            }
             currentVC.present(alertController, animated: true, completion: nil)
        }
    }
}

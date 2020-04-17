//
//  OnePageController.swift
//  ShineApp
//
//  Created by jiang.123 on 2020/3/21.
//  Copyright © 2020 jiang.123. All rights reserved.
//

import UIKit

class OnePageController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
          self.view.backgroundColor = mainColor
            self.navigationItem.title = "一张图"
            let alertLabel = UILabel()
            alertLabel.text = "功能暂待后期开发"
            alertLabel.frame = CGRect(x: 0, y: self.view.frame.height * 0.5 - 10, width: mScreenW, height: 20)
            alertLabel.textColor = UIColor.white
            alertLabel.textAlignment = .center
            self.view.addSubview(alertLabel)
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

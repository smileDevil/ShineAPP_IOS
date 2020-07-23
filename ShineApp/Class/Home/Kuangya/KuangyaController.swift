//
//  KuangyaController.swift
//  ShineApp
//
//  Created by jiang.123 on 2020/7/2.
//  Copyright © 2020 jiang.123. All rights reserved.
//

import UIKit

class KuangyaController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "爆炸感知"
        
        let mimageView = UIImageView(frame: CGRect(x: 0, y: 0, width: mScreenW, height: mScreenH-navigationBarHeight))

        mimageView.image = UIImage.init(named:"bzt.jpeg")
        mimageView.contentMode = .scaleAspectFit
        self.view.addSubview(mimageView)
        
    }
}

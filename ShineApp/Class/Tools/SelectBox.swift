//
//  SelectView1.swift
//  ShineApp
//
//  Created by jiang.123 on 2020/3/31.
//  Copyright © 2020 jiang.123. All rights reserved.
//

import UIKit

//屏幕的宽和高 用于构建蒙板
let DeviceWidth = UIScreen.main.bounds.size.width
let DeviceHeight = UIScreen.main.bounds.size.height

class SelectBox: UIView {

    var selectBoxLabel: UILabel!
    var coverView: UIView!
    var containView: UIView!
    var titles: [String] = []
    var containViewHeight = CGFloat(0)
    var isPullDown = false

    init(frame: CGRect,titles: [String]) {
        self.titles = titles
        super.init(frame: frame)
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.blue.cgColor
        initView()
    }

    required init?(coder aDecoder: NSCoder) {
    
        fatalError("init(coder:) has not been implemented")
    }

    //初始化视图
    func initView() {
    
        let width = self.frame.size.width
        let height = self.frame.size.height
        selectBoxLabel = UILabel(frame: CGRect(x: 0.1 * width, y: 0, width: 0.5 * width , height: height ))
        selectBoxLabel.text = titles[0]
        let selectBoxBtn = UIButton(frame: CGRect(x: 0.7 * width, y: 0, width: 0.3 * width, height: height))
        selectBoxBtn.backgroundColor = UIColor.blue
        selectBoxBtn.setImage(UIImage(named: "selectBox1"), for: .normal)
        selectBoxBtn.addTarget(self, action: #selector(self.showContainView), for: .touchUpInside)
        self.addSubview(selectBoxLabel)
        self.addSubview(selectBoxBtn)
    
        containViewHeight = height * CGFloat(titles.count)
        containView =  UIView(frame: CGRect(x: self.frame.origin.x, y: self.frame.origin.y + height, width: self.frame.size.width, height: containViewHeight))
        containView.layer.borderWidth = 2
        containView.layer.borderColor = UIColor.blue.cgColor
        containView.backgroundColor = UIColor.lightGray
    
        for i in 0..<titles.count {
        
            let containLabel = UILabel(frame: CGRect(x: 0.1 * width, y: CGFloat(i) * height, width: 0.9 * width, height: height))
            containLabel.isUserInteractionEnabled = true
            containLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.selectLableEvent(recognizer:))))
            containLabel.text = titles[i]
            containLabel.tag = 1000 + i
            containView.addSubview(containLabel)
        }
    
        coverView = UIView(frame: CGRect(x: 0, y: 0, width: DeviceWidth, height: DeviceHeight))
        coverView.backgroundColor = UIColor.clear
    coverView.addGestureRecognizer(UITapGestureRecognizer(target: self, action:     #selector(self.pullUpEvent(recognizer:))))
        coverView.isUserInteractionEnabled = true
        coverView.addSubview(containView)

    }
    //弹出下拉视图
    @objc func showContainView() {

        isPullDown = !isPullDown
        if isPullDown {

            self.superview?.addSubview(coverView)
            //self.superview?.addSubview(containView)
        
        } else {
            coverView.removeFromSuperview()
        
        }
    
    }

    // 通过手势选中下拉视图中的一项内容时触发该事件
    @objc func selectLableEvent (recognizer:     UIGestureRecognizer) {
        guard let tag = recognizer.view?.tag else {
            return
        }
        for i in 0..<titles.count {
            if i == tag - 1000 {
                selectBoxLabel.text = titles[i]
            }
        }
    
        coverView.removeFromSuperview()
    }

    //收起下拉视图
    @objc func pullUpEvent(recognizer: UIGestureRecognizer) {
        coverView.removeFromSuperview()
    
    }

}

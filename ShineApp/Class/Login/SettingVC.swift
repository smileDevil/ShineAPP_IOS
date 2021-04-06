//
//  SettingVC.swift
//  ShineApp
//
//  Created by jiang.123 on 2020/11/28.
//  Copyright © 2020 jiang.123. All rights reserved.
//

import UIKit

class SettingVC: BaseViewController {
    
    @IBOutlet weak var ipText: UITextField!
    @IBOutlet weak var portText: UITextField!
    @IBOutlet weak var userText: UITextField!
    @IBOutlet weak var psdText: UITextField!
    @IBOutlet weak var testLinkButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "设置服务地址"
        //渐变色
        let layer = CAGradientLayer()
        layer.frame = CGRect(x: 0, y: 0, width: (JYBWindowWidth - 60), height: 40)//按钮所在区域
        layer.startPoint = CGPoint(x: 0, y: 0)
        layer.endPoint = CGPoint(x: 1, y: 0)
        let starColor = UIColor.init(r: 33, g: 121, b: 232)
        let endColor = UIColor.init(r: 2, g: 232, b: 106)
        layer.colors = [starColor.cgColor, endColor.cgColor]
        layer.locations = [0, 1]
        testLinkButton.layer.addSublayer(layer)
        
        testLinkButton.layer.cornerRadius = 20;
        testLinkButton.clipsToBounds = true;
        testLinkButton.addTarget(self, action: #selector(testClick), for: .touchUpInside)
        
        let ipPlaceholder =  NSAttributedString(string: "输入ip", attributes: [NSAttributedString.Key.foregroundColor:placeholderColor])
        ipText.attributedPlaceholder = ipPlaceholder
        ipText.delegate = self;
        let portPlaceholder =  NSAttributedString(string: "输入端口", attributes: [NSAttributedString.Key.foregroundColor:placeholderColor])
        portText.attributedPlaceholder = portPlaceholder
        portText.delegate = self
        
        let userPlaceholder =  NSAttributedString(string: "输入用户名", attributes: [NSAttributedString.Key.foregroundColor:placeholderColor])
        userText.attributedPlaceholder = userPlaceholder
        userText.delegate = self
        let psdPlaceholder =  NSAttributedString(string: "输入密码", attributes: [NSAttributedString.Key.foregroundColor:placeholderColor])
        psdText.attributedPlaceholder = psdPlaceholder
        psdText.delegate = self
        
        
        let ip = UserDefaults.standard.string(forKey: "ip") ?? ""
        let port = UserDefaults.standard.string(forKey: "port") ?? ""
        if ip.count > 0 {
            ipText.text = ip
        }
        if port.count > 0 {
            portText.text = port
        }
        // Do any additional setup after loading the view.
    }
    
    
}


extension SettingVC{
    @objc func testClick(){
        self.view.endEditing(true)
        testLinkButton.setTitle("正在测试连接......", for: .normal)
        let ip = ipText.text!
        let port = portText.text!
        let user = userText.text!
        let psd = psdText.text!
        
        if(ip.count <= 0) {
            AlertHepler.showAlert(titleStr: nil, msgStr: "ip不能为空", currentVC: self, cancelHandler: { (canleAction) in
                return
            }, otherBtns: nil, otherHandler: nil)
            return
        }
        if(port.count <= 0){
            AlertHepler.showAlert(titleStr: nil, msgStr: "port不能为空", currentVC: self, cancelHandler: { (canleAction) in
                return
            }, otherBtns: nil, otherHandler: nil)
            return
        }
        if(user.count <= 0){
            AlertHepler.showAlert(titleStr: nil, msgStr: "用户名不能为空", currentVC: self, cancelHandler: { (canleAction) in
                return
            }, otherBtns: nil, otherHandler: nil)
            return
        }
        if(psd.count <= 0){
            AlertHepler.showAlert(titleStr: nil, msgStr: "密码不能为空", currentVC: self, cancelHandler: { (canleAction) in
                return
            }, otherBtns: nil, otherHandler: nil)
            return
        }
        let parameters = ["UserName":user,"PassWord":psd]
        let url = "http://" + ip + ":" + port + "/SHHWebService.asmx/GetOtherLoginInfo"
        NetworkTools.requestData(type: .GET, url: url, paramenters: parameters) { (result) in
            guard let resultDic =  result as? [String : NSObject]else {
                let returnstr = result as? String
                if returnstr != "" {
                    self.testLinkButton.setTitle("测试失败,请重新测试", for: .normal)
                    AlertHepler.showAlert(titleStr: "提示", msgStr: returnstr, currentVC: self, cancelHandler: nil, otherBtns: nil, otherHandler: nil)
                }else{
                    AlertHepler.showAlert(titleStr: "提示", msgStr: "登录失败,请确认ip、端口、账号、密码是否输入正确", currentVC: self, cancelHandler: nil, otherBtns: nil, otherHandler: nil)
                }
                return
            }
            let resultArr = resultDic["rows"] as? [[String : NSObject]]
            if resultArr != nil {
                self.testLinkButton.setTitle("测试成功", for: .normal)
                var httpUrl = ""
                if ip.contains("http"){
                    httpUrl = ip+":"+port+"/SHHWebService.asmx/"
                }else{
                    httpUrl = "http://" + ip + ":" + port + "/SHHWebService.asmx/"
                }
                UserDefaults.standard.set(httpUrl, forKey: "httpUrl")
                UserDefaults.standard.set(ip,forKey:"ip")
                UserDefaults.standard.set(port,forKey:"port")
            }else{
                self.testLinkButton.setTitle("测试失败,请重新测试", for: .normal)
                
                AlertHepler.showAlert(titleStr: "提示", msgStr: "登录失败,请确认ip、端口、账号、密码是否输入正确", currentVC: self, cancelHandler: nil, otherBtns: nil, otherHandler: nil)
            }
            
        }
        
    }
}

extension SettingVC : UITextFieldDelegate{
    
    //此处省略引用声明
    //通过委托来实现放弃第一响应者
    //UITextField Delegate Method
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    //通过委托来实现放弃第一响应者
    //UITextView Delegate  Method
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
}


//
//  LoginViewController.swift
//  CarHelperdemo
//
//  Created by jiang.123 on 2019/7/26.
//  Copyright © 2019 jiang.123. All rights reserved.
//

import UIKit
import Alamofire
class LoginViewController: BaseViewController {
    //
    @IBOutlet weak var userBackView: UIView!
    @IBOutlet weak var psdBackView: UIView!
    @IBOutlet weak var userTextFiled: UITextField!
    @IBOutlet weak var psdTextFiled: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var loadImageView: UIImageView!
    @IBOutlet weak var loadBackView: UIView!
    @IBOutlet weak var settingBtn: UIButton!
    //创建viewmodel实例
    private lazy var loginViewModel: LoginViewModel = LoginViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        setUpViews();
        //网络检测
        currentNetReachability()
        //注册点击事件
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        
        let momAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        momAnimation.fromValue=NSNumber(value:0)//左幅度
        momAnimation.toValue=NSNumber(value:Double.pi*2)//右幅度
        momAnimation.duration=1
        momAnimation.repeatCount=HUGE//无限重复
        loadImageView.layer.add(momAnimation, forKey: "centerLayer")
        
    }
    
    @IBAction func settingBtnClick(_ sender: UIButton) {
        self.navigationController?.pushViewController(SettingVC(), animated: true)
    }
    
    //进入组册页面
    @IBAction func registerBtnClick(_ sender: Any) {
//        self.navigationController?.pushViewController(RegisterVC(), animated: true)
        let vc = MyNavigationController(rootViewController: RegisterVC())

        UIApplication.shared.windows[0].rootViewController =  vc
    }
    
    func currentNetReachability() {
        let manager = NetworkReachabilityManager()
        manager?.listener = { status in
            var statusStr: String?
            switch status {
            case .unknown:
                statusStr = "未识别的网络"
                break
            case .notReachable:
                statusStr = "不可用的网络(未连接)"
            case .reachable:
                if (manager?.isReachableOnWWAN)! {
                    statusStr = "2G,3G,4G...的网络"
                } else if (manager?.isReachableOnEthernetOrWiFi)! {
                    statusStr = "wifi的网络";
                }
                break
            }
            if statusStr == "不可用的网络(未连接)"{
                AlertHepler.showAlert(titleStr: nil, msgStr: "当前网络不可用,请选择可用网络", currentVC: self, cancelHandler: { (canleAction) in
                    return
                }, otherBtns: nil, otherHandler: nil)
            }
        }
        manager?.startListening()
    }
    
    
}
extension LoginViewController{
    func setUpViews() {
        //设置属性
        loginBtn.layer.cornerRadius = 20;
        loginBtn.clipsToBounds = true;
        loginBtn.addTarget(self, action: #selector(loginClick), for: .touchUpInside)
        
        userBackView.layer.cornerRadius = 20;
        //        userBackView.clipsToBounds = true;
        psdBackView.layer.cornerRadius = 20;
        //        psdBackView.clipsToBounds = true;
        let userPlaceholder =  NSAttributedString(string: "输入用户名", attributes: [NSAttributedString.Key.foregroundColor:placeholderColor])
        userTextFiled.attributedPlaceholder = userPlaceholder
        userTextFiled.delegate = self;
        let psdPlaceholder =  NSAttributedString(string: "输入密码", attributes: [NSAttributedString.Key.foregroundColor:placeholderColor])
        psdTextFiled.attributedPlaceholder = psdPlaceholder
        psdTextFiled.delegate = self;
        
        //渐变色
        let layer = CAGradientLayer()
        layer.frame = CGRect(x: 0, y: 0, width: (JYBWindowWidth - 60), height: 40)//按钮所在区域
        layer.startPoint = CGPoint(x: 0, y: 0)
        layer.endPoint = CGPoint(x: 1, y: 0)
        let starColor = UIColor.init(r: 33, g: 121, b: 232)
        let endColor = UIColor.init(r: 2, g: 232, b: 106)
        layer.colors = [starColor.cgColor, endColor.cgColor]
        layer.locations = [0, 1]
        loginBtn.layer.addSublayer(layer)
        //获取有无登录账号密码, 有则填入
        let userStr : String =  UserDefaults.standard.string(forKey: "user") ?? ""
        if userStr != "" {
            userTextFiled.text = userStr
        }
        let psdStr : String = UserDefaults.standard.string(forKey: "password") ?? ""
        if psdStr != "" {
            psdTextFiled.text = psdStr
        }
        
        self.settingBtn.isHidden  = false
       // isShowSetting()
    }
    
    func isShowSetting(){
             var url = UserDefaults.standard.string(forKey: "httpUrl") ?? ""
                   if url == "" {
                       url = REQUESTURL + "GetAppIsShowSetting"
                   }else{
                       url = url + "GetAppIsShowSetting"
                   }
             NetworkTools.requestData(type: .GET, url: url) { (result) in
                if result.isKind(of: NSMutableString.self){
                     self.settingBtn.isHidden  = true
                    return
                }
                let resultDic = result as? [String : Bool]
                if resultDic == nil {
                    self.settingBtn.isHidden  = true
                    return
                }
                let isShow : Bool = resultDic!["IsShowSetting"]!
                if isShow {
                    self.settingBtn.isHidden = false
                }else{
                    self.settingBtn.isHidden  = true
                }
             }
         }
     
    
    
    @objc func loginClick(){
        
       // UIApplication.shared.windows[0].rootViewController = MyNavigationController(rootViewController: KJ70DataController())
       // return;
        let user : String = userTextFiled.text ?? ""
        let psd : String = psdTextFiled.text ?? ""
            
        if(user.count <= 0) {
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
        

//        let registerId = UserDefaults.standard.string(forKey: "registId") ?? ""
        
        loadBackView.isHidden = false
        //极光推送Rid传入数据库
        loginViewModel.registerRid()
        //登录操作
        loginViewModel.requestData(userName: user, psd: psd) {
            self.loadBackView.isHidden = true
            if(self.loginViewModel.mineModelList.count > 0 ){
                let mine :MineModel = self.loginViewModel.mineModelList[0]
                UserDefaults.standard.set(mine.Minecode, forKey: "mineCode")
                UserDefaults.standard.set(mine.SimpleName,forKey: "mineName")
                UserDefaults.standard.set(user, forKey: "user")
                UserDefaults.standard.set(psd, forKey: "password")

                UIApplication.shared.windows[0].rootViewController = MyNavigationController(rootViewController: HomeController())
               
                
            }else{
                if self.loginViewModel.loginReturnStr != "" {
                    AlertHepler.showAlert(titleStr: "提示", msgStr: self.loginViewModel.loginReturnStr, currentVC: self, cancelHandler: { (cancleAction) in
                        return
                    }, otherBtns: nil, otherHandler: nil)
                }else {
                AlertHepler.showAlert(titleStr: "提示", msgStr: "帐号没有满足条件的煤矿数据", currentVC: self, cancelHandler: { (cancleAction) in
                    return
                }, otherBtns: nil, otherHandler: nil)
                }
            }
        }
        
    }
    //    收回键盘
    @objc func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            userTextFiled.resignFirstResponder()
            psdTextFiled.resignFirstResponder()
        }
        sender.cancelsTouchesInView = false
    }
    
}

extension LoginViewController : UITextFieldDelegate{
    
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

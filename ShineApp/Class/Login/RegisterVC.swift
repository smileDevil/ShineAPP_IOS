//
//  RegisterVC.swift
//  ShineApp
//
//  Created by jiang.123 on 2020/5/7.
//  Copyright © 2020 jiang.123. All rights reserved.
//

import UIKit

class RegisterVC: BaseViewController {
    @IBOutlet weak var userBackView: UIView!
    @IBOutlet weak var psdBackView: UIView!
    @IBOutlet weak var secpsdBackView: UIView!
    @IBOutlet weak var userTextFiled: UITextField!
    @IBOutlet weak var psdTextFiled: UITextField!
    @IBOutlet weak var secpsdTextFiled: UITextField!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var agreementBtn: UIButton!
    @IBOutlet weak var loadImageView: UIImageView!
    @IBOutlet weak var loadBackView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        
        //注册动画
        let momAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        momAnimation.fromValue=NSNumber(value:0)//左幅度
        momAnimation.toValue=NSNumber(value:Double.pi*2)//右幅度
        momAnimation.duration=1
        momAnimation.repeatCount=HUGE//无限重复
        loadImageView.layer.add(momAnimation, forKey: "centerLayer")
        setUpViews()
    }
    
    //    收回键盘
      @objc func handleTap(sender: UITapGestureRecognizer) {
          if sender.state == .ended {
              userTextFiled.resignFirstResponder()
              psdTextFiled.resignFirstResponder()
              secpsdTextFiled.resignFirstResponder()
          }
          sender.cancelsTouchesInView = false
      }
  
}

extension RegisterVC {
    func setUpViews() {
        self.navigationItem.title = "注册"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back_arrow.png")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(backToPrevious))
//        self.view.backgroundColor = mainColor
//        let topView = UIView(frame: CGRect(x: 0, y: 0, width: mScreenW, height: navigationBarHeight))
//        topView.backgroundColor = mainColor
//        
//
//        let topTitlelabel = UILabel(frame:CGRect(x: (mScreenW - 200) * 0.5 , y: 10,width: 200,height: navigationBarHeight - 10))
//        topTitlelabel.text = "注册"
//        topTitlelabel.textAlignment = .center
//        topTitlelabel.textColor = UIColor.white
//        topTitlelabel.font = UIFont.systemFont(ofSize: 16)
//        topView.addSubview(topTitlelabel)
//        self.view.addSubview(topView)
//        
//        let backButton = UIButton(frame: CGRect(x: 15, y: 10, width: 30, height: navigationBarHeight - 10))
//        backButton.setImage(UIImage(named: "back_arrow.png"), for: .normal)
//        topView.addSubview(backButton)
        
        //设置属性
        registerBtn.layer.cornerRadius = 20;
        registerBtn.clipsToBounds = true;
        registerBtn.addTarget(self, action: #selector(registerClick), for: .touchUpInside)
        
        agreementBtn.addTarget(self, action: #selector(agreementClick), for: .touchUpInside)
        
        userBackView.layer.cornerRadius = 20;
        //        userBackView.clipsToBounds = true;
        psdBackView.layer.cornerRadius = 20;
        secpsdBackView.layer.cornerRadius = 20
        //        psdBackView.clipsToBounds = true;
        let userPlaceholder =  NSAttributedString(string: "输入用户名", attributes: [NSAttributedString.Key.foregroundColor:placeholderColor])
        userTextFiled.attributedPlaceholder = userPlaceholder
        userTextFiled.delegate = self;
        let psdPlaceholder =  NSAttributedString(string: "输入密码", attributes: [NSAttributedString.Key.foregroundColor:placeholderColor])
        psdTextFiled.attributedPlaceholder = psdPlaceholder
        psdTextFiled.delegate = self;
        
        let secpsdPlaceholder =  NSAttributedString(string: "输入确认密码", attributes: [NSAttributedString.Key.foregroundColor:placeholderColor])
        secpsdTextFiled.attributedPlaceholder = secpsdPlaceholder
        secpsdTextFiled.delegate = self;
        
        //渐变色
        let layer = CAGradientLayer()
        layer.frame = CGRect(x: 0, y: 0, width: (JYBWindowWidth - 60), height: 40)//按钮所在区域
        layer.startPoint = CGPoint(x: 0, y: 0)
        layer.endPoint = CGPoint(x: 1, y: 0)
        let starColor = UIColor.init(r: 33, g: 121, b: 232)
        let endColor = UIColor.init(r: 2, g: 232, b: 106)
        layer.colors = [starColor.cgColor, endColor.cgColor]
        layer.locations = [0, 1]
        registerBtn.layer.addSublayer(layer)
    }
    
    @objc func registerClick(){
        let user : String = userTextFiled.text ?? ""
        let psd : String = psdTextFiled.text ?? ""
        let secpsd : String = secpsdTextFiled.text ?? ""
        
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
        if psd != secpsd {
            AlertHepler.showAlert(titleStr: nil, msgStr: "两次输入密码不相同", currentVC: self, cancelHandler: { (canleAction) in
                                  return
                              }, otherBtns: nil, otherHandler: nil)
                              return
        }
        
        var hasUser = false
        var userArr = UserDefaults.standard.object(forKey: "userArr") as? [String] ?? [String]()
        var passArr = UserDefaults.standard.object(forKey: "passArr") as? [String] ?? [String]()
        for str in userArr {
            if str == user {
                hasUser = true
            }
        }
        if hasUser {
            AlertHepler.showAlert(titleStr: nil, msgStr: "该用户已存在", currentVC: self, cancelHandler: { (canleAction) in
                                             return
                                         }, otherBtns: nil, otherHandler: nil)
                                         return
        }
        else{
            userArr.append(user)
            passArr.append(psd)
            UserDefaults.standard.set(userArr, forKey: "userArr")
            UserDefaults.standard.set(passArr,forKey: "passArr")
              AlertHepler.showAlert(titleStr: nil, msgStr: "注册成功", currentVC: self, cancelHandler: { (canleAction) in
                                                        UIApplication.shared.windows[0].rootViewController = LoginViewController()
            }, otherBtns: nil, otherHandler: nil)
            return
           
        }
            
    }
    
    @objc func agreementClick(){
        self.navigationController?.pushViewController(RegisterAgreementVC(), animated: true)
    }
    
    @objc func backToPrevious(){
        UIApplication.shared.windows[0].rootViewController = LoginViewController()
    }
}


extension RegisterVC : UITextFieldDelegate{
    
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

//
//  KJ128DataController.swift
//  ShineApp
//
//  Created by jiang.123 on 2020/4/21.
//  Copyright © 2020 jiang.123. All rights reserved.
//

import UIKit

class KJ128DataController: UIViewController {
        var pickerView:UIPickerView!
        var pickerBottomView : UIView!
        var dismissView :UIView!
        var navTitView : NavTitleView!
        fileprivate let navTitleArr : [String] = ["128实时数据","128历史数据"]
        override func viewDidLoad() {
            super.viewDidLoad()
            initView()
          
        }

    }

extension KJ128DataController{
    func initView(){
        
          navTitView = NavTitleView(frame: CGRect(x: 0, y: 0, width: 140, height: cvTopNavHeight))
          navTitView.titleBtn?.addTarget(self, action: #selector(chooseDataType), for: .touchUpInside)
          navTitView.titleBtn?.setTitle("128实时数据", for: .normal)
          self.navigationItem.titleView = navTitView
          
          let titles = ["人员信息","实时报警","分站状态","区域信息"]//"车辆信息",
          let style  = TJTitleStyle()
                 style.isScrollEnable = false
                 style.isShowBottomLine = true
                 style.isShowCover = false
          var childVcs = [UIViewController]()
          childVcs.append(KJ128RealTimePoepleVC())
//          childVcs.append(KJ128RealTimeCarsVC())
          childVcs.append(KJ128RealTimeWaringVC())
          childVcs.append(KJ128RealTimeStationStateVC())
          childVcs.append(KJ128RealTimeAreaVC())
         
          let frame = CGRect(x: 0, y: 0, width: mScreenW, height: mScreenH - navigationBarHeight)
          
          let pageView = TJPageView(frame: frame, titles: titles, style: style, childVcs: childVcs, parentVc: self)
          
          self.view.addSubview(pageView)
      }
      
      @objc func chooseDataType(sender:UIButton){
          if dismissView == nil {
            createPickView()
          }
      }
}

extension KJ128DataController:UIPickerViewDelegate,UIPickerViewDataSource {

    //创建pickview
       func createPickView()  {
           view.endEditing(true)
           dismissView = UIView(frame: CGRect(x: 0, y: 0, width: mScreenW, height: mScreenH))
           dismissView.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.35)
           dismissView.isUserInteractionEnabled = true
           let dismisTap = UITapGestureRecognizer(target: self, action: #selector(dismissTap))
           dismisTap.numberOfTapsRequired = 1
           dismissView.addGestureRecognizer(dismisTap)
           self.view.addSubview(dismissView)
           
           let pickH :CGFloat = 300
           pickerBottomView =  UIView(frame: CGRect(x: 0, y: mScreenH - pickH, width: mScreenW, height:pickH))
           pickerBottomView.backgroundColor = mainColor
           self.view.addSubview(pickerBottomView)
           
           let actionView =  UIView(frame: CGRect(x: 0, y:0, width: mScreenW, height:30))
//           actionView.layer.borderColor =  UIColor.gray.cgColor
//           actionView.layer.borderWidth = 0.5
           pickerBottomView.addSubview(actionView)
           
           let button = UIButton(frame:CGRect(x: mScreenW-100, y: 0, width: 90, height: 30))
          button.setTitleColor(UIColor.white, for: .normal)
           button.setTitle("确定", for: .normal)
           button.addTarget(self, action: #selector(getPickerViewValue), for: .touchUpInside)
           actionView.addSubview(button)
           
           pickerView = UIPickerView(frame: CGRect(x: 0, y: 30, width: mScreenW, height:pickH-30))
           //delegate设为自己
           pickerView.delegate = self
           //DataSource设为自己
           pickerView.dataSource = self
           pickerView.backgroundColor = mainColor
           //设置PickerView默认值
           pickerView.selectRow(1, inComponent: 0, animated: true)
           pickerBottomView.addSubview(pickerView)
       }
    
    //pickview 确定s事件,获取选中的值
       @objc func getPickerViewValue(){
           let row = pickerView.selectedRow(inComponent: 0)
           let titleStr =  navTitleArr[row]
           dismissTap()
            if(titleStr == "128历史数据" ){
                
                self.navigationController?.pushViewController(KJ128HistorySearchVC(), animated: true)
//                self.navigationController?.pushViewController(KJ70HistorySearchController(), animated: true)
            }
       }
       
      //设置PickerView列数(dataSourse协议)
      func numberOfComponents(in pickerView: UIPickerView) -> Int {
          return 1  //返回多少行
      }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return navTitleArr.count
    }
      //设置PickerView行数(dataSourse协议)      //设置PickerView选项内容(delegate协议)
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return navTitleArr[row]
      }
      
      //检测响应选项的选择状态
      func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
          
        //navTitView.titleBtn?.setTitle(navTitleArr[row], for: .normal)
     
      }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {

         //这里宽度随便给的， 高度也是随便给的 不能比row的高度大，能显示出来就行
         let showLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
         showLabel.textAlignment = .center
         showLabel.textColor = UIColor.white
         showLabel.text = navTitleArr[row]
         //重新加载label的文字内容
         return showLabel
     }
    
    //取消界面的pickview 和dismissView
      @objc func dismissTap(){
          UIView.animate(withDuration: 0.5, animations: {
              self.pickerBottomView.frame = CGRect(x: 0, y:mScreenH, width: mScreenW, height:0)
              self.dismissView.frame = CGRect(x: 0, y:mScreenH, width: mScreenW, height:0)
          }) { (_) in
              self.pickerBottomView.removeFromSuperview()
              self.dismissView.removeFromSuperview()
            self.dismissView = nil
          }
      }
      
       
}

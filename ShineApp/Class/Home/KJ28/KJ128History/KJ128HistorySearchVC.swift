//
//  KJ128HistorySearchVC.swift
//  ShineApp
//
//  Created by jiang.123 on 2020/4/29.
//  Copyright © 2020 jiang.123. All rights reserved.
//

import UIKit
class KJ128HistorySearchVC: BaseViewController
{
    let lineMargin : CGFloat = 10
    var pickerView:UIPickerView!
      var datePicker:UIDatePicker!
      var pickerBottomView : UIView!
      var dismissView :UIView!
      var datePickView : UIView!
      var navTitView : NavTitleView = NavTitleView()
      var mFlag = 1 // 1 title 值 2 开始时间  3 结束时间 4 设备类型选择 5 传感器选择
    private var sensorLabel : UILabel!
    private var jobCardSelecttView = TypeSelectView()
    private lazy var jobCardNameTypeArr : [String] = [String]()
     private lazy var jobCardTypeArr : [PersonNameModel] = [PersonNameModel]()
     private var selectjobCardModel : PersonNameModel!
    @IBOutlet var topTimeView: UIView!
       @IBOutlet weak var beginTimeBgView: UIView!
       @IBOutlet weak var begintTimeLabel: UILabel!
       @IBOutlet weak var beginTimeBtn: UIButton!
       private var beginDate : Date!
       @IBOutlet weak var endTimeBgView: UIView!
       @IBOutlet weak var endTimeBtn: UIButton!
       @IBOutlet weak var endTimeLabel: UILabel!
       private var endDate : Date!
    fileprivate let navTitleArr : [String] = ["历史井下时间","历史超时报警","历史超员报警","历史超员/限制区域报警","历史求救报警","历史分站状态","历史区域信息","历史考勤"]
    fileprivate var selectTitle = "历史井下时间"
      private lazy var myViewModel :KJ128HistoryViewModel = KJ128HistoryViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
    self.view.backgroundColor = mainColor
       initView()
        
    }
}

extension KJ128HistorySearchVC {
    func initView(){
        navTitView = NavTitleView(frame: CGRect(x: 0, y: 0, width: 180, height: cvTopNavHeight))
        navTitView.titleBtn?.addTarget(self, action: #selector(chooseDataType), for: .touchUpInside)
        navTitView.titleBtn?.setTitle("历史井下时间", for: .normal)
        self.navigationItem.titleView = navTitView
        
        topTimeView.frame = CGRect(x: 0, y: 0, width: mScreenW, height: 90)
        self.beginTimeBgView.clipsToBounds = true
        self.beginTimeBgView.layer.cornerRadius = 20
        self.beginTimeBtn.addTarget(self, action: #selector(beginTimeBtnClick), for: .touchUpInside)
        self.endTimeBgView.clipsToBounds = true
        self.endTimeBgView.layer.cornerRadius = 20
        self.endTimeBtn.addTarget(self, action: #selector(endTimeBtnClick), for: .touchUpInside)
        self.view.addSubview(topTimeView)
    
        //测点信息选择标签
        sensorLabel = UILabel(frame: CGRect(x: 15, y: topTimeView.frame.height + topTimeView.frame.origin.y + lineMargin, width: 100, height: 20))
        sensorLabel.textColor  = UIColor.white
        sensorLabel.text = "卡号"
        sensorLabel.font = UIFont.systemFont(ofSize: 13)
        self.view.addSubview(sensorLabel)
        //测点选择框
        jobCardSelecttView.frame = CGRect(x: 15, y: sensorLabel.frame.height + sensorLabel.frame.origin.y +  lineMargin, width: mScreenW - 30, height: 40)
        jobCardSelecttView.typeSelectBtn.addTarget(self, action: #selector(jobCardSelect), for: .touchUpInside)
        self.view.addSubview(jobCardSelecttView)
        // 确认按钮
        
        let makeSureBtn = UIButton(frame: CGRect(x: 15, y: jobCardSelecttView.frame.height  + jobCardSelecttView.frame.origin.y + 60, width: mScreenW - 30 , height: 40))
        makeSureBtn.backgroundColor = greenColor
        makeSureBtn.setTitle("确认", for: .normal)
        makeSureBtn.setTitleColor(UIColor.white, for: .normal)
        makeSureBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        makeSureBtn.clipsToBounds = true
        makeSureBtn.layer.cornerRadius = 20
        makeSureBtn.addTarget(self, action: #selector(makeSureClick), for: .touchUpInside)
        self.view.addSubview(makeSureBtn)
        //获取当前系统时间
        getNowDate()
        //获取设备类型数据
        getAllPersons()
    }
    
    
    
    //类型历史选择
    @objc func chooseDataType(sender:UIButton){
        if dismissView == nil {
            mFlag = 1
            createPickView(flag: mFlag)
        }
    }
    //设备提交
    @objc func jobCardSelect(){
        mFlag = 4
        createPickView(flag: mFlag)
    }

    
    @objc func beginTimeBtnClick(){
        mFlag = 2
        createPickView(flag: mFlag)
    }
    @objc func endTimeBtnClick(){
        mFlag = 3
        createPickView(flag: mFlag)
    }
    //时间改变监控
    @objc func dateChanged(){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let date = formatter.string(from: datePicker.date)
        if(mFlag == 2 ){
            self.begintTimeLabel.text = date
            beginDate = datePicker.date
        }
        
        if(mFlag == 3 ){
            self.endTimeLabel.text = date
            endDate = datePicker.date
        }
    }
    
    
    //获取当前系统时间
    func getNowDate(){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let date  = Date()
        self.begintTimeLabel.text = formatter.string(from: date)
        self.endTimeLabel.text = formatter.string(from: date)
    }
    
    //获取人员编号
    func getAllPersons(){
        //获取可选择类型
        myViewModel.getKJ128PersonLists{
            self.jobCardTypeArr.removeAll()
              self.jobCardNameTypeArr.removeAll()
            if self.myViewModel.peopleModels.count > 0 {
              
                self.jobCardTypeArr = self.myViewModel.peopleModels
                self.jobCardNameTypeArr.append("全部")
                for model in self.jobCardTypeArr {
                    
                    self.jobCardNameTypeArr.append("\(model.Name ?? "") \(model.JobCardCode ?? "" ) " )
                }
            }else{
                self.jobCardTypeArr.removeAll()
                self.jobCardNameTypeArr.removeAll()
            }
        }
    }
    //点击确认按钮
    @objc func makeSureClick(){
      
            let vc : KJ128HistoryDataListVC = KJ128HistoryDataListVC()
            vc.beginDate = self.begintTimeLabel.text! + " 00:00:00"
            vc.endDate = self.endTimeLabel.text! + " 23:59:29"
           vc.jobCardCode = selectjobCardModel == nil ? "" : selectjobCardModel.JobCardCode
           // vc.mSensor = selectSensorModel == nil ? "" : String(selectSensorModel.SensorNum)
            vc.searchTitle = self.selectTitle
            self.navigationController?.pushViewController(vc, animated: true)
      }
}


extension KJ128HistorySearchVC:UIPickerViewDelegate,UIPickerViewDataSource{
    //创建pickview
    func createPickView(flag:Int)  {
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
        
        let actionView =  UIView(frame: CGRect(x: 0, y:0, width: mScreenW, height:40))
        //           actionView.layer.borderColor =  UIColor.gray.cgColor
        //           actionView.layer.borderWidth = 0.5
        pickerBottomView.addSubview(actionView)
        
        let button = UIButton(frame:CGRect(x: mScreenW-100, y: 5, width: 90, height: 30))
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitle("确定", for: .normal)
        button.addTarget(self, action: #selector(getPickerViewValue), for: .touchUpInside)
        actionView.addSubview(button)
        
        if flag == 1 || flag == 4 {
            pickerView = UIPickerView(frame: CGRect(x: 0, y: 40, width: mScreenW, height:pickH-40))
            //delegate设为自己
            pickerView.delegate = self
            //DataSource设为自己
            pickerView.dataSource = self
            pickerView.backgroundColor = mainColor
            //设置PickerView默认值
            pickerView.selectRow(0, inComponent: 0, animated: true)
            pickerBottomView.addSubview(pickerView)
        }else if flag == 2 || flag == 3{
            
            datePicker = UIDatePicker(frame: CGRect(x: 0, y: 40, width: mScreenW, height:pickH-40))
            datePicker.locale = NSLocale(localeIdentifier: "zh_CN") as Locale
            datePicker.setValue(UIColor.white, forKey: "textColor")
            datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
            datePicker.datePickerMode = .date
            datePicker.maximumDate = Date()
            if flag == 2 && endDate != nil {
                datePicker.maximumDate = endDate
            }
            
            if flag == 3 && beginDate != nil {
                datePicker.minimumDate = beginDate
            }
            pickerBottomView.addSubview(datePicker)
        }
    }
    
    
    
    //pickview 确定s事件,获取选中的值
    @objc func getPickerViewValue(){
        if mFlag == 2 || mFlag == 3 {
            
        }else{
            let row = pickerView.selectedRow(inComponent: 0)
            if mFlag == 1 {
                let titleStr =  navTitleArr[row]
                if(titleStr == "历史超员报警" ){
//                    jobCardSelecttView.isHidden = true
//                    sensorLabel.isHidden = true
//                    topTimeView.isHidden = true
                    jobCardSelecttView.isUserInteractionEnabled = false
                    beginTimeBtn.isUserInteractionEnabled = false
                    endTimeBtn.isUserInteractionEnabled = false
                }else if(titleStr == "历史分站状态"){
//                    jobCardSelecttView.isHidden = true
//                    sensorLabel.isHidden = true
//                    topTimeView.isHidden = false
                    jobCardSelecttView.isUserInteractionEnabled = false
                                      beginTimeBtn.isUserInteractionEnabled = true
                                      endTimeBtn.isUserInteractionEnabled = true
                }
                else{
//                     jobCardSelecttView.isHidden = false
//                    sensorLabel.isHidden = false
//                    topTimeView.isHidden = false
                    jobCardSelecttView.isUserInteractionEnabled = true
                    beginTimeBtn.isUserInteractionEnabled = true
                    endTimeBtn.isUserInteractionEnabled = true
                }
                self.selectTitle = titleStr
                self.navTitView.titleBtn?.setTitle(titleStr, for: .normal)
            }
            if mFlag == 4 {
                let titler = jobCardNameTypeArr[row]
               
                self.jobCardSelecttView.typeNameLabel.text = titler
         
                
                if(row != 0 ){
                    self.selectjobCardModel = self.jobCardTypeArr[row - 1]
                    
                }else {
                    self.selectjobCardModel = nil
              
                }
            }
        
        }
        dismissTap()
        
    }
    //设置PickerView列数(dataSourse协议)
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1  //返回多少行
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if mFlag == 1 {
            return navTitleArr.count
        } else if mFlag == 4 {
            return jobCardNameTypeArr.count
        }
        else {
            return 0
        }
    }
    //设置PickerView行数(dataSourse协议)      //设置PickerView选项内容(delegate协议)
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if mFlag == 1 {
            return navTitleArr[row]
        }else if mFlag == 4 {
            return jobCardNameTypeArr[row]
        }else {
            return ""
        }
    }
    
    //检测响应选项的选择状态
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        //navTitView.titleBtn?.setTitle(navTitleArr[row], for: .normal)
        
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        //这里宽度随便给的， 高度也是随便给的 不能比row的高度大，能显示出来就行
        let showLabel = UILabel(frame: CGRect(x: 0, y: 0, width: mScreenW, height: 20))
        showLabel.textAlignment = .center
        showLabel.textColor = UIColor.white
        if mFlag == 1 {
            showLabel.text = navTitleArr[row]
        }else if mFlag == 4 {
            showLabel.text = jobCardNameTypeArr[row]
        }
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



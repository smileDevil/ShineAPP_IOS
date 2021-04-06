//
//  KJ70HistorySearchController.swift
//  ShineApp
//
//  Created by jiang.123 on 2020/4/7.
//  Copyright © 2020 jiang.123. All rights reserved.
//

import UIKit

let lineMargin : CGFloat = 10

class KJ70HistorySearchController: BaseViewController {
    var pickerView:UIPickerView!
    var datePicker:UIDatePicker!
    var pickerBottomView : UIView!
    var dismissView :UIView!
    var datePickView : UIView!
    var navTitView : NavTitleView = NavTitleView()
    var mFlag = 1 // 1 title 值 2 开始时间  3 结束时间 4 设备类型选择 5 传感器选择
    private var mDeviceTypeSelectView = TypeSelectView()
    private var mSensorSelectView = TypeSelectView()
    @IBOutlet var topTimeView: UIView!
    @IBOutlet weak var beginTimeBgView: UIView!
    @IBOutlet weak var begintTimeLabel: UILabel!
    @IBOutlet weak var beginTimeBtn: UIButton!
    @IBOutlet weak var endTimeBgView: UIView!
    @IBOutlet weak var endTimeBtn: UIButton!
    @IBOutlet weak var endTimeLabel: UILabel!
    private var endDate : Date!
      private var beginDate : Date!
    
    fileprivate let navTitleArr : [String] = ["历史报警","历史预警","历史设备故障","历史断电","历史模拟量","历史开关量","历史模拟量折线图"]//,"历史模拟量折线图"
    fileprivate var selectTitle = "历史报警"
    private lazy var myViewModel : RealTimeWaringViewModel = RealTimeWaringViewModel()
    private lazy var deviceNameTypeArr : [String] = [String]()
    private lazy var deviceTypeArr : [KJ70DeviceTypeModel] = [KJ70DeviceTypeModel]()
    private var selectDeviceModel : KJ70DeviceTypeModel!
    private lazy var sensorNameTypeArr : [String] = [String]()
    private lazy var sensorTypeArr : [KJ70SensorModel] = [KJ70SensorModel]()
    private var selectSensorModel : KJ70SensorModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = mainColor
        initView()
    }
}

extension KJ70HistorySearchController {
    
    func initView(){
        
        navTitView = NavTitleView(frame: CGRect(x: 0, y: 0, width: 180, height: cvTopNavHeight))
        navTitView.titleBtn?.addTarget(self, action: #selector(chooseDataType), for: .touchUpInside)
        navTitView.titleBtn?.setTitle("历史报警", for: .normal)
        self.navigationItem.titleView = navTitView
        
        topTimeView.frame = CGRect(x: 0, y: 0, width: mScreenW, height: 90)
        self.beginTimeBgView.clipsToBounds = true
        self.beginTimeBgView.layer.cornerRadius = 20
        self.beginTimeBtn.addTarget(self, action: #selector(beginTimeBtnClick), for: .touchUpInside)
        self.endTimeBgView.clipsToBounds = true
        self.endTimeBgView.layer.cornerRadius = 20
        self.endTimeBtn.addTarget(self, action: #selector(endTimeBtnClick), for: .touchUpInside)
        self.view.addSubview(topTimeView)
        //添加设备标题
        let deviceLabel = UILabel(frame: CGRect(x: 15, y: topTimeView.frame.height + 10, width: 100, height: 20))
        deviceLabel.textColor  = UIColor.white
        deviceLabel.text = "设备名称"
        deviceLabel.font = UIFont.systemFont(ofSize: 13)
        self.view.addSubview(deviceLabel)
        
        mDeviceTypeSelectView.frame = CGRect(x: 15, y: deviceLabel.frame.height + deviceLabel.frame.origin.y +  lineMargin, width: mScreenW - 30, height: 40)
        mDeviceTypeSelectView.typeSelectBtn.addTarget(self, action: #selector(deviceSelect), for: .touchUpInside)
        self.view.addSubview(mDeviceTypeSelectView)
        //测点信息选择标签
        let sensorLabel = UILabel(frame: CGRect(x: 15, y: mDeviceTypeSelectView.frame.height + mDeviceTypeSelectView.frame.origin.y + lineMargin, width: 100, height: 20))
        sensorLabel.textColor  = UIColor.white
        sensorLabel.text = "测点"
        sensorLabel.font = UIFont.systemFont(ofSize: 13)
        self.view.addSubview(sensorLabel)
        //测点选择框
        mSensorSelectView.frame = CGRect(x: 15, y: sensorLabel.frame.height + sensorLabel.frame.origin.y +  lineMargin, width: mScreenW - 30, height: 40)
        mSensorSelectView.typeSelectBtn.addTarget(self, action: #selector(sensorSelect), for: .touchUpInside)
        self.view.addSubview(mSensorSelectView)
        // 确认按钮
        
        let makeSureBtn = UIButton(frame: CGRect(x: 15, y: mSensorSelectView.frame.height  + mSensorSelectView.frame.origin.y + 60, width: mScreenW - 30 , height: 40))
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
        getDeviceTypes()
    }
    
    
    //类型历史选择
    @objc func chooseDataType(sender:UIButton){
        if dismissView == nil {
            mFlag = 1
            createPickView(flag: mFlag)
        }
    }
    //设备提交
    @objc func deviceSelect(){
        mFlag = 4
        if self.deviceTypeArr.count <= 0 {
            AlertHepler.showAlert(titleStr: "提示", msgStr: "没有获取到设备信息,是否重新获取", currentVC: self, cancelHandler: { (canleAction) in
                return
            }, otherBtns: ["确认"]) { (makesureAction) in
                self.getDeviceTypes()
            }
        }else{
              createPickView(flag: mFlag)
        }
      
        
    }
    //传感器选择
    @objc func sensorSelect(){
        if self.selectDeviceModel != nil {
            mFlag = 5
            createPickView(flag: mFlag)
        }
        
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
    
    //获取设备类型
    func getDeviceTypes(){
        //获取可选择类型
        myViewModel.getDeviceTypeList {
            self.deviceTypeArr.removeAll()
            if self.myViewModel.deviceTypeList.count > 0 {
                self.deviceNameTypeArr.removeAll()
                self.deviceTypeArr = self.myViewModel.deviceTypeList
                self.deviceNameTypeArr.append("全部")
                for model in self.deviceTypeArr {
                    self.deviceNameTypeArr.append(model.TypeName)
                }
            }else{
                self.deviceTypeArr.removeAll()
                self.deviceNameTypeArr.removeAll()
            }
        }
    }
    //点击确认按钮
    @objc func makeSureClick(){
        if self.selectTitle == "历史模拟量折线图" {
            if(selectSensorModel == nil) {
                AlertHepler.showAlert(titleStr: nil, msgStr: "需要选择测点", currentVC: self, cancelHandler: { (canleAction) in
                return
             }, otherBtns: nil, otherHandler: nil)
                  return
            }
            if !(self.begintTimeLabel.text == self.endTimeLabel.text) {
                AlertHepler.showAlert(titleStr: nil, msgStr: "开始时间和结束时间必须为同一天", currentVC: self, cancelHandler: { (canleAction) in
                        
                            }, otherBtns: nil, otherHandler: nil)
                       return
            }
            let vc : LineChartsVC = LineChartsVC()
            vc.beginDate = self.begintTimeLabel.text! + " 00:00:00"
            vc.endDate = self.endTimeLabel.text! + " 23:59:29"
            vc.mSensor = selectSensorModel == nil ? "" : String(selectSensorModel.SensorNum)
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            let vc : Kj70HistoryListController = Kj70HistoryListController()
            vc.beginDate = self.begintTimeLabel.text! + " 00:00:00"
            vc.endDate = self.endTimeLabel.text! + " 23:59:29"
            vc.mDeviceType = selectDeviceModel == nil ? "" : String(selectDeviceModel!.TypeCode)
            vc.mSensor = selectSensorModel == nil ? "" : String(selectSensorModel.SensorNum)
            vc.searchTitle = self.selectTitle
            self.navigationController?.pushViewController(vc, animated: true)
        }

    }
}
extension KJ70HistorySearchController:UIPickerViewDelegate,UIPickerViewDataSource{
    //创建pickview
    func createPickView(flag:Int){
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
        
        if flag == 1 || flag == 4 || flag == 5 {
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
                self.selectTitle = titleStr
                self.navTitView.titleBtn?.setTitle(titleStr, for: .normal)
            }
            if mFlag == 4 {
                let titler = deviceNameTypeArr[row]
                self.mDeviceTypeSelectView.typeNameLabel.text = titler
                self.sensorNameTypeArr.removeAll()
                self.sensorTypeArr.removeAll()
                
                if(row != 0 ){
                    
                    self.selectDeviceModel = self.deviceTypeArr[row - 1]
                    myViewModel.getSensorList(typeCode: self.selectDeviceModel.TypeCode
                    , type: self.selectDeviceModel.Type) {
                        if self.myViewModel.sensorList.count > 0 {
                            self.sensorTypeArr = self.myViewModel.sensorList
                            self.sensorNameTypeArr.append("全部")
                            for model in self.sensorTypeArr {
                                self.sensorNameTypeArr.append("\(model.SensorNum) \(model.Place)" )
                            }
                        }else{
                            self.sensorTypeArr.removeAll()
                            self.sensorNameTypeArr.removeAll()
                        }
                    }
                    
                }else {
                    self.selectDeviceModel = nil
                    self.selectSensorModel = nil
                }
            }
            if mFlag == 5 {
                let title = sensorNameTypeArr[row]
                self.mSensorSelectView.typeNameLabel.text = title
                if row != 0 {
                    self.selectSensorModel = self.sensorTypeArr[row - 1 ]
                }else{
                    self.selectSensorModel = nil
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
            return deviceNameTypeArr.count
        }else if mFlag == 5 {
            return  sensorNameTypeArr.count
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
            return deviceNameTypeArr[row]
        }else if mFlag == 5 {
            return sensorNameTypeArr[row]
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
            showLabel.text = deviceNameTypeArr[row]
        }else if mFlag == 5 {
            showLabel.text = sensorNameTypeArr[row]
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

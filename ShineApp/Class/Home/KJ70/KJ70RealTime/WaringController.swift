//
//  WaringController.swift
//  ShineApp
//
//  Created by jiang.123 on 2020/3/25.
//  Copyright © 2020 jiang.123. All rights reserved.
//

import UIKit
import MJRefresh
private let HEAD_VIEW_HEIGHT = 40
private let CellStr : String = "RealTimeWaringCell"
private let typeCellStr = "TypeViewCell"
private var mModelList : [RealTimeWaringModel] = [RealTimeWaringModel]()
private var mUrl : String =  "GetKj70RealTimeAlarmInfo"
private var mTypName : String = ""

class WaringController: BaseViewController {
    var pickerView:UIPickerView!
    var pickerBottomView : UIView!
    var dismissView :UIView!
    var rightViewDisMissViw : UIView!
    private var mRightView = UIView()// 右侧滑动view
    private var mRightTypeSelectView = TypeSelectView()
    private lazy var myViewModel : RealTimeWaringViewModel = RealTimeWaringViewModel()
    private lazy var sensorNameTypeArr : [String] = [String]()
    private lazy var sensorTypeArr : [KJ70DeviceTypeModel] = [KJ70DeviceTypeModel]()
    private let typeNameArr : [String] = ["实时报警","实时断电","馈电异常","组合报警","组合断电","逻辑报警"]
    private var noDataView : ListStateView = ListStateView()
    
    fileprivate lazy var typeTableView : UITableView  = {
        let tableview = UITableView(frame: CGRect(x: 10, y: HEAD_VIEW_HEIGHT, width: 60, height: 120))
        tableview.delegate = self
        tableview.dataSource = self
        tableview.tag = 1002
        tableview.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableview.register(UINib(nibName: typeCellStr, bundle: nil), forCellReuseIdentifier: typeCellStr)
        tableview.backgroundColor = mainColor
        tableview.isHidden = true
        return tableview
    }()
    
    fileprivate lazy var tableView : UITableView  = {
        let tableview = UITableView(frame: CGRect(x: 0, y: HEAD_VIEW_HEIGHT, width: Int(mScreenW), height: Int(mScreenH) - HEAD_VIEW_HEIGHT - cvTopNavHeight - Int(navigationBarHeight)))
        tableview.delegate = self
        tableview.dataSource = self
        tableview.tag = 1001
        tableview.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableview.register(UINib(nibName: CellStr, bundle: nil), forCellReuseIdentifier: CellStr)
        tableview.backgroundColor = mainColor
        return tableview
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
}

extension WaringController{
    
    func  initView(){
        
        self.view.backgroundColor = mainColor
        let headView : UIView  = UIView()
        headView.frame = CGRect(x: 0, y: 0, width: Int(mScreenW), height: HEAD_VIEW_HEIGHT)
        headView.backgroundColor = mainColor
        self.view.addSubview(headView)
        
        let typeBtn = UIButton(frame: CGRect(x: 10, y: 0, width: 60, height: HEAD_VIEW_HEIGHT))
        typeBtn.addTarget(self, action: #selector(showTypeSelect), for: .touchUpInside)
        typeBtn.setTitle("实时报警", for: .normal)
        typeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        typeBtn.titleLabel?.textAlignment = .left
        headView.addSubview(typeBtn)
        
        let arrowDownImagVew = UIImageView(frame: CGRect(x: typeBtn.frame.width + typeBtn.frame.origin.x  + 5, y: 10, width: 20, height: 20))
        arrowDownImagVew.image = UIImage(named: "arrow_down.png")
        headView.addSubview(arrowDownImagVew)
        
        //添加搜索按钮
        let searchBtn = UIButton(frame:CGRect(x: Int(mScreenW - 26 - 15), y: 0, width: 26, height: HEAD_VIEW_HEIGHT))
        searchBtn.setImage(UIImage(named: "shaixuan"), for: .normal)
        headView.addSubview(searchBtn)
        searchBtn.addTarget(self, action: #selector(showRightView), for: .touchUpInside)
        self.view.addSubview(tableView)
        noDataView.frame = CGRect(x: 0, y: HEAD_VIEW_HEIGHT, width: Int(mScreenW), height: Int(mScreenH) - HEAD_VIEW_HEIGHT - cvTopNavHeight - Int(navigationBarHeight))
               noDataView.isHidden = true
               self.view.addSubview(noDataView)
        self.view.addSubview(typeTableView)
        addRightView()
        getDeviceTypes()
        setRefresh()
    }
    
    //添加刷新
    func setRefresh(){
        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(getData))
        // 2.设置header属性
        header?.setTitle("下拉刷新", for: .idle);
        header?.setTitle("释放刷新", for: .pulling)
        header?.setTitle("加载中...", for: .refreshing)
        header?.setTitle("", for: .willRefresh)
        header?.lastUpdatedTimeLabel.isHidden = true
        // 3.设置tableview的header
        tableView.mj_header = header
        // 4.开始刷新
        tableView.mj_header.beginRefreshing()
    }
    //获取数据
    @objc func getData(){
        //获取数据
        myViewModel.requestData(url: mUrl,typeName: mTypName) {
            mModelList.removeAll()
            if self.myViewModel.modelList.count > 0 {
                mModelList = self.myViewModel.modelList
                self.noDataView.isHidden = true
                                }else{
                self.noDataView.isHidden = false
                              }
            self.tableView.mj_header.endRefreshing()
            self.tableView.reloadData()
        }
    }
    func getDeviceTypes(){
        //获取可选择类型
        myViewModel.getDeviceTypeList {
            self.sensorTypeArr.removeAll()
            if self.myViewModel.deviceTypeList.count > 0 {
                self.sensorNameTypeArr.removeAll()
                self.sensorTypeArr = self.myViewModel.deviceTypeList
                self.sensorNameTypeArr.append("全部")
                for model in self.sensorTypeArr {
                    self.sensorNameTypeArr.append(model.TypeName)
                }
            }else{
                self.sensorTypeArr.removeAll()
                self.sensorNameTypeArr.removeAll()
            }
        }
    }
    //打开x下来选择
    @objc func showTypeSelect(){
        typeTableView.isHidden = !typeTableView.isHidden
    }
    
    func addRightView(){
        
        rightViewDisMissViw = UIView(frame: CGRect(x: mScreenW, y: 0, width: mScreenW, height: mScreenH))
        rightViewDisMissViw.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.35)
        rightViewDisMissViw.isUserInteractionEnabled = true
        let dismisTap = UITapGestureRecognizer(target: self, action: #selector(hiddenRightView))
        dismisTap.numberOfTapsRequired = 1
        rightViewDisMissViw.addGestureRecognizer(dismisTap)
        self.view.addSubview(rightViewDisMissViw)
        //
        mRightView = UIView(frame: CGRect(x:Int(mScreenW) , y: 0, width: 200, height: Int(mScreenH) -  HEAD_VIEW_HEIGHT - cvTopNavHeight - Int(navigationBarHeight)))
        mRightView.backgroundColor = mainColor
        
        let typeLabel = UILabel(frame: CGRect(x: 15, y: 10, width: 40, height: 20))
        typeLabel.text = "类型"
        typeLabel.font = UIFont.systemFont(ofSize: 14)
        typeLabel.textColor = UIColor.white
        mRightView.addSubview(typeLabel)
        
        mRightTypeSelectView.frame = CGRect(x: 10, y: 30, width: 120, height: 30)
        mRightTypeSelectView.typeSelectBtn.addTarget(self, action: #selector(createPickView), for: .touchUpInside)
        mRightView.addSubview(mRightTypeSelectView)
        self.view.addSubview(mRightView)
    }
    //贼噶把事故右侧滑动窗
    @objc func showRightView() {
        UIView.animate(withDuration: 0.5, animations: {
            self.mRightView.frame = CGRect(x:Int(mScreenW) - 200 , y: 0, width: 200, height: Int(mScreenH) - HEAD_VIEW_HEIGHT - cvTopNavHeight - Int(navigationBarHeight))
            
            if(self.rightViewDisMissViw != nil){
                self.rightViewDisMissViw.frame = CGRect(x: 0, y: 0, width: mScreenW, height: mScreenH)
            }
        }) { (_) in
            
        }
    }
    
    @objc func hiddenRightView(){
        UIView.animate(withDuration: 0.5, animations: {
            
            self.mRightView.frame = CGRect(x:Int(mScreenW) , y: 0, width: 200, height: Int(mScreenH) - HEAD_VIEW_HEIGHT - cvTopNavHeight - Int(navigationBarHeight))
            self.rightViewDisMissViw.frame = CGRect(x: mScreenW, y: 0, width: mScreenW, height: mScreenH)
        }) { (_) in
            
        }
    }
}

extension WaringController : UIPickerViewDelegate,UIPickerViewDataSource{
    //创建pickview
    @objc func createPickView()  {
        
        dismissView = UIView(frame: CGRect(x: 0, y: 0, width: mScreenW, height: mScreenH))
        dismissView.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.35)
        dismissView.isUserInteractionEnabled = true
        let dismisTap = UITapGestureRecognizer(target: self, action: #selector(dismissTap))
        dismisTap.numberOfTapsRequired = 1
        dismissView.addGestureRecognizer(dismisTap)
        self.view.addSubview(dismissView)
        view.endEditing(true)
        
        let pickH :CGFloat = 300
        pickerBottomView =  UIView(frame: CGRect(x: 0, y: self.view.frame.height - pickH  , width: mScreenW, height:pickH))
        pickerBottomView.backgroundColor = mainColor
        self.view.addSubview(pickerBottomView)
        
        let actionView =  UIView(frame: CGRect(x: 0, y:0, width: mScreenW, height:40))
        
        
        pickerBottomView.addSubview(actionView)
        
        let button = UIButton(frame:CGRect(x: mScreenW-100, y: 5, width: 90, height: 30))
        //           button.setTitleColor(UIColor.init(r: 68, g: 174, b: 85), for: .normal)
        button.setTitleColor(UIColor.white,for: .normal)
        button.setTitle("确定", for: .normal)
        button.addTarget(self, action: #selector(getPickerViewValue), for: .touchUpInside)
        actionView.addSubview(button)
        
        pickerView = UIPickerView(frame: CGRect(x: 0, y: 40, width: mScreenW, height:pickH-40))
        //delegate设为自己
        pickerView.delegate = self
        //DataSource设为自己
        pickerView.dataSource = self
        pickerView.backgroundColor = mainColor
        //设置PickerView默认值
        pickerView.selectRow(0, inComponent: 0, animated: true)
        pickerBottomView.addSubview(pickerView)
    }
    
    
    //pickview 确定s事件,获取选中的值
    @objc func getPickerViewValue(){
        let row = pickerView.selectedRow(inComponent: 0)
        let titleStr =  sensorNameTypeArr[row]
        self.mRightTypeSelectView.typeNameLabel.text = titleStr
        if(row == 0 ) {
            mTypName = ""
        }else {
            let model = self.sensorTypeArr[row - 1]
            mTypName = model.TypeName
        }
        dismissTap()
        self.tableView.mj_header.beginRefreshing()
    }
    
    //设置PickerView列数(dataSourse协议)
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1  //返回多少行
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sensorNameTypeArr.count
    }
    //设置PickerView行数(dataSourse协议)      //设置PickerView选项内容(delegate协议)
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sensorNameTypeArr[row]
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
        showLabel.text = sensorNameTypeArr[row]
        //重新加载label的文字内容
        return showLabel
    }
    
    //取消界面的pickview 和dismissView
    @objc func dismissTap(){
        UIView.animate(withDuration: 0.5, animations: {
            if(self.pickerBottomView != nil ){
                self.pickerBottomView.frame = CGRect(x: 0, y:mScreenH, width: mScreenW, height:0)
                self.dismissView.frame = CGRect(x: 0, y:mScreenH, width: mScreenW, height:0)
                
            }
            //同事隐藏弹出右边栏
            self.hiddenRightView()
        }) { (_) in
            if(self.pickerBottomView != nil ){
                self.pickerBottomView.removeFromSuperview()
                self.dismissView.removeFromSuperview()
            }
            
        }
    }
    
}

extension WaringController : UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView.tag == 1001) {
            return mModelList.count
        }else{
            return typeNameArr.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if tableView.tag == 1001{
            let cell = tableView.dequeueReusableCell(withIdentifier: CellStr,for: indexPath) as! RealTimeWaringCell
            let model = mModelList[indexPath.row]
            cell.placeLabel.text = model.Place
            cell.stateLabel.text = "[\(model.ValueState)]"
            cell.numLabel.text = model.SensorNum
            cell.vallabel.text = "值: \(model.ShowValue)"
            cell.typeLabel.text = "类型: \(model.TypeName)"
            cell.dataLabel.text = model.DateTime
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: typeCellStr,for: indexPath) as! TypeViewCell
            cell.nameLabel.text = typeNameArr[indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(tableView.tag == 1002 ){
            let typeName = typeNameArr[indexPath.row]
            if typeName == "实时报警" {
                mUrl = "GetKj70RealTimeAlarmInfo"
            }else if typeName == "实时断电"{
                mUrl = "GetKj70RealTimeOutPowerInfo"
            }else if typeName == "馈电异常"{
                mUrl = "GetKj70RealTimeAbnormalFeedInfo"
            }else if typeName == "组合报警"{
                mUrl = "GetKj70RealTimeCombinationAlarmInfo"
            }else if typeName == "组合断电"{
                mUrl = "GetKj70RealTimeCombinationOutageInfo"
            }else  {
                mUrl = "GetKj70RealTimeLogicAlarmInfo"
            }
            tableView.isHidden = true
            self.tableView.mj_header.beginRefreshing()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(tableView.tag == 1001) {
            return 75
        }else{
            return 30
        }
    }
    
}

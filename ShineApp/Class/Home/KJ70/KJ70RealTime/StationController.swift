//
//  StationController.swift
//  ShineApp
//
//  Created by jiang.123 on 2020/3/25.
//  Copyright © 2020 jiang.123. All rights reserved.
//

import UIKit
import MJRefresh
private let HEAD_VIEW_HEIGHT = 40
private let CellStr : String = "RealTimeStationCell"
private var mModelList : [RealTimeStationModel] = [RealTimeStationModel]()
private var countLabel : UILabel = UILabel()
class StationController: BaseViewController {
    var pickerView:UIPickerView!
    var pickerBottomView : UIView!
    var dismissView :UIView!
    var rightViewDisMissViw : UIView!
    private var mRightView = UIView()// 右侧滑动view
    private var mRightTypeSelectView = TypeSelectView()
    private lazy var sensorNameTypeArr : [String] = [String]()
    private var mTypName : String = ""
    private lazy var sensorTypeArr : [KJ70DeviceTypeModel] = [KJ70DeviceTypeModel]()
    private lazy var myViewModel : RealTimeRequestModel = RealTimeRequestModel()
    
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
        // Do any additional setup after loading the view.
    }
    
    func  initView(){
        self.view.backgroundColor = mainColor
        let headView : UIView  = UIView()
        headView.frame = CGRect(x: 0, y: 0, width: Int(mScreenW), height: HEAD_VIEW_HEIGHT)
        headView.backgroundColor = mainColor
        self.view.addSubview(headView)
        
        countLabel.frame = CGRect(x: 15, y: 0, width: 120, height: HEAD_VIEW_HEIGHT)
        countLabel.font = UIFont.systemFont(ofSize: 12)
        countLabel.textColor = UIColor.white
        countLabel.textAlignment = .left
        headView.addSubview(countLabel)
        //添加搜索按钮
        let searchBtn = UIButton(frame:CGRect(x: Int(mScreenW - 26 - 15), y: 0, width: 26, height: HEAD_VIEW_HEIGHT))
        searchBtn.setImage(UIImage(named: "shaixuan"), for: .normal)
        headView.addSubview(searchBtn)
        searchBtn.addTarget(self, action: #selector(showRightView), for: .touchUpInside)
        searchBtn.isHidden = true //隐藏
        self.view.addSubview(tableView)
        addRightView()
        
        getDeviceTypes()
        setRefresh()
    }
    //添加refresh
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
    
    @objc func getData(){
        //获取数据
        myViewModel.requestStationData  {
            countLabel.text = "总数:\(self.myViewModel.stationCount)条"
            
            mModelList.removeAll()
            if self.myViewModel.stationCount > 0 {
                mModelList = self.myViewModel.realTimeStationModels
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


extension StationController : UIPickerViewDelegate,UIPickerViewDataSource{
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
        pickerBottomView =  UIView(frame: CGRect(x: 0, y: mScreenH - pickH, width: mScreenW, height:pickH))
        pickerBottomView.backgroundColor = mainColor
        self.view.addSubview(pickerBottomView)
        
        let actionView =  UIView(frame: CGRect(x: 0, y:0, width: mScreenW, height:30))
        
        
        pickerBottomView.addSubview(actionView)
        
        let button = UIButton(frame:CGRect(x: mScreenW-100, y: 0, width: 90, height: 30))
        //           button.setTitleColor(UIColor.init(r: 68, g: 174, b: 85), for: .normal)
        button.setTitleColor(UIColor.white,for: .normal)
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


extension StationController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return mModelList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellStr,for: indexPath) as! RealTimeStationCell
        let model = mModelList[indexPath.row]
        cell.placeLabel.text = "所在区域: \(model.Place)"
        let stateStr = model.ValueState
        switch stateStr {
        case "报警":
            cell.stateLabel.textColor = waringColor
            break
        case "正常":cell.stateLabel.textColor = successColor
            break
        case "故障":cell.stateLabel.textColor = errorColor
            break
        default:cell.stateLabel.textColor = errorColor
            break
        }
        cell.stateLabel.text = "[\(stateStr)]"
        
        cell.numLabel.text = "分站编号: \(model.SensorNum)"
        cell.mineNameLabel.text = model.SimpleName
        cell.dateTimelabel.text = "监测时间: \(model.Datetime)"
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
}

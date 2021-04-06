//
//  HomeWaringListViewController.swift
//  ShineApp
//
//  Created by jiang.123 on 2020/12/18.
//  Copyright © 2020 jiang.123. All rights reserved.
//

import UIKit
import MJRefresh
private let CellStr : String = "HomeWaringListCell"
private let RightCell : String = "HomeWaringRightListCell"
private let insideTableW  = 200
private let insideTableL = Int(mScreenW) - insideTableW


class HomeWaringListViewController: BaseViewController {
    
    private var mHomeWaringTypeList:[HomeWaringTypeModel] = [HomeWaringTypeModel]()
    
    private var mHomeWaringStaticModel : HomeWaringStataicsModel?
    private var mHomeWaringRightList:[HomeWaringRightModel] = [HomeWaringRightModel]()
    private var selectTypeName:String = ""
    
    private lazy var homeViewModel : HomeWaringViewModel = HomeWaringViewModel()
    private var rightTableVeiwBgView:UIView!
    fileprivate lazy var rightTableView : UITableView  = {
        let tableview = UITableView(frame: CGRect(x: Int(mScreenW), y: 0, width: insideTableW, height:  Int(mScreenH)  - Int(navigationBarHeight)))
        tableview.delegate = self
        tableview.dataSource = self
        tableview.tag = 1002
        tableview.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableview.register(UINib(nibName: RightCell, bundle: nil), forCellReuseIdentifier: RightCell)
        tableview.backgroundColor = mainColor
        tableview.isHidden = true
        return tableview
    }()
    
    fileprivate lazy var tableView : UITableView  = {
        let tableview = UITableView(frame: CGRect(x: 0, y: 0, width: Int(mScreenW), height: Int(mScreenH)  - Int(navigationBarHeight)))
        tableview.delegate = self
        tableview.dataSource = self
        tableview.tag = 1001
       // tableview.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableview.register(UINib(nibName: CellStr, bundle: nil), forCellReuseIdentifier: CellStr)
        tableview.backgroundColor = mainColor
        return tableview
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "报警统计"
        self.view.addSubview(tableView)
        
        rightTableVeiwBgView = UIView(frame: CGRect(x: mScreenW, y: 0, width: mScreenW, height: mScreenH))
        rightTableVeiwBgView.backgroundColor = .black
        rightTableVeiwBgView.alpha = 0.3
        rightTableVeiwBgView.isHidden = true
        rightTableVeiwBgView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hiddenRightView)))
        self.view.addSubview(rightTableVeiwBgView)
        self.view.addSubview(rightTableView)
        setRefresh()
    }
    
    //贼噶把事故右侧滑动窗
    @objc func showRightView() {
       rightTableView.isHidden = false
       rightTableVeiwBgView.isHidden = false
        UIView.animate(withDuration: 0.5, animations: {
            self.rightTableView.frame = CGRect(x: Int(mScreenW) - insideTableW,  y: 0, width: insideTableW, height: Int(mScreenH)  - Int(navigationBarHeight))
            
            self.rightTableVeiwBgView.frame = CGRect(x: 0, y: 0, width: mScreenW - CGFloat(insideTableW), height: mScreenH)
            
        }) { (_) in
            
        }
    }
    
    //一场右侧弹出框
         @objc func hiddenRightView(){
             self.view.endEditing(true)
             UIView.animate(withDuration: 0.5, animations: {
                 self.rightTableView.frame = CGRect(x:Int(mScreenW) , y: 0, width: insideTableW, height: Int(mScreenH)  - Int(navigationBarHeight))
                 self.rightTableVeiwBgView.frame = CGRect(x: mScreenW, y: 0, width: mScreenW, height: mScreenH)
             }) { (_) in
                       self.rightTableView.isHidden = true
                        self.rightTableVeiwBgView.isHidden = true
             }
         }
    //加入刷新
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
        
        
        let rightTableViewHeader = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(getRightData))
        // 2.设置header属性
        rightTableViewHeader?.setTitle("下拉刷新", for: .idle);
        rightTableViewHeader?.setTitle("释放刷新", for: .pulling)
        rightTableViewHeader?.setTitle("加载中...", for: .refreshing)
        rightTableViewHeader?.setTitle("", for: .willRefresh)
        rightTableViewHeader?.lastUpdatedTimeLabel.isHidden = true
        rightTableView.mj_header = rightTableViewHeader
    }
    @objc func getData() {
        homeViewModel.requestHomeWaringListData {
            self.mHomeWaringStaticModel = self.homeViewModel.mHomeWaringModel
            self.doHomeWaringTypeAction()
            self.tableView.mj_header.endRefreshing()
        }
    }
    
    @objc func getRightData(){
        homeViewModel.requestHomeWaringRightListData(typeName: selectTypeName) {
            self.mHomeWaringRightList = self.homeViewModel.mHomeWaringRightList
            self.rightTableView.reloadData()
            self.rightTableView.mj_header.endRefreshing()
            
        }
    }
    
    func doHomeWaringTypeAction(){
        if(self.mHomeWaringStaticModel == nil){
            return
        }
        
        if(mHomeWaringStaticModel?.矿井超时 != nil){
            let modelDic = ["typeName":"矿井超时","value":mHomeWaringStaticModel?.矿井超时 ?? ""]
            let  model : HomeWaringTypeModel = HomeWaringTypeModel(dict: modelDic)
            mHomeWaringTypeList.append(model)
        }
        if(mHomeWaringStaticModel?.矿井超员 != nil){
            let modelDic = ["typeName":"矿井超时","value":mHomeWaringStaticModel?.矿井超员 ?? ""]
            let  model : HomeWaringTypeModel = HomeWaringTypeModel(dict: modelDic)
            mHomeWaringTypeList.append(model)
        }
        if(mHomeWaringStaticModel?.区域超时 != nil){
            let modelDic = ["typeName":"区域超时","value":mHomeWaringStaticModel?.区域超时 ?? ""]
            let  model : HomeWaringTypeModel = HomeWaringTypeModel(dict: modelDic)
            mHomeWaringTypeList.append(model)
        }
        if(mHomeWaringStaticModel?.区域超员 != nil){
            let modelDic = ["typeName":"区域超员","value":mHomeWaringStaticModel?.区域超员 ?? ""]
            let  model : HomeWaringTypeModel = HomeWaringTypeModel(dict: modelDic)
            mHomeWaringTypeList.append(model)
        }
        if(mHomeWaringStaticModel?.人员定位分站故障 != nil){
            let modelDic = ["typeName":"人员定位分站故障","value":mHomeWaringStaticModel?.人员定位分站故障 ?? ""]
            let  model : HomeWaringTypeModel = HomeWaringTypeModel(dict: modelDic)
            mHomeWaringTypeList.append(model)
        }
        if(mHomeWaringStaticModel?.安全监控传感器故障 != nil){
            let modelDic = ["typeName":"安全监控传感器故障","value":mHomeWaringStaticModel?.安全监控传感器故障 ?? ""]
            let  model : HomeWaringTypeModel = HomeWaringTypeModel(dict: modelDic)
            mHomeWaringTypeList.append(model)
        }
        if(mHomeWaringStaticModel?.安全监控分站故障 != nil){
            let modelDic = ["typeName":"安全监控分站故障","value":mHomeWaringStaticModel?.安全监控分站故障 ?? ""]
            let  model : HomeWaringTypeModel = HomeWaringTypeModel(dict: modelDic)
            mHomeWaringTypeList.append(model)
        }
        if(mHomeWaringStaticModel?.断电 != nil){
            let modelDic = ["typeName":"断电","value":mHomeWaringStaticModel?.断电 ?? ""]
            let  model : HomeWaringTypeModel = HomeWaringTypeModel(dict: modelDic)
            mHomeWaringTypeList.append(model)
        }
        if(mHomeWaringStaticModel?.超限 != nil){
            let modelDic = ["typeName":"超限","value":mHomeWaringStaticModel?.超限 ?? ""]
            let  model : HomeWaringTypeModel = HomeWaringTypeModel(dict: modelDic)
            mHomeWaringTypeList.append(model)
        }
        
        self.tableView.reloadData()
    }
}

extension HomeWaringListViewController : UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView.tag == 1001) {
            return mHomeWaringTypeList.count
        }else{
            return mHomeWaringRightList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if tableView.tag == 1001{
            let cell = tableView.dequeueReusableCell(withIdentifier: CellStr,for: indexPath) as! HomeWaringListCell
            let model = mHomeWaringTypeList[indexPath.row]
            cell.titlleLabel.text = "\(model.typeName ?? ""): \(model.value ?? "0")"
            if model.typeName == "矿井超员" {
                cell.rightImageView.isHidden = true
            }else{
                cell.rightImageView.isHidden = false
            }
            
            if selectTypeName == model.typeName! {
                cell.bottomLineView.backgroundColor = successColor
            }else{
                cell.bottomLineView.backgroundColor = .white
            }
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: RightCell,for: indexPath) as! HomeWaringRightListCell
            let model = mHomeWaringRightList[indexPath.row]
            cell.label5.isHidden = false
            cell.label4.isHidden = false
            if selectTypeName == "矿井超时" {
                cell.label1.text = "\(model.JobCardCode) \(model.Name)"
                cell.label2.text = "部门名称: \(model.Department)"
                cell.label3.text = "入井时间: \(model.InTime)"
                cell.label4.text = "报警时间: \(model.StartAlTime)"
                cell.label5.isHidden = true
            }else if selectTypeName == "区域超时" {
                cell.label1.text = "\(model.JobCardCode) \(model.Name)"
                cell.label2.text = "部门名称: \(model.Department)"
                cell.label3.text = "区域名称: \(model.AreaName)"
                cell.label4.text = "进入时间: \(model.InAreaTime)"
                cell.label5.text = "报警开始: \(model.StartAlTime)"
            }else if selectTypeName == "区域超员" {
                cell.label1.text = "区域名称: \(model.AreaName)"
                cell.label2.text = "额定人数 \(model.limitNum)"
                cell.label3.text = "现有人数: \(model.NowNum)"
                cell.label4.text = "超员人数: \(model.CYNum)"
                cell.label5.text = "超员时间: \(model.Time)"
            }else if selectTypeName == "人员定位分站故障" {
                cell.label1.text = "分站名称: \(model.StationName)"
                cell.label2.text = "分站编号: \(model.StationCode)"
                cell.label3.text = "分站位置: \(model.Place)"
                cell.label4.isHidden = true
                cell.label5.isHidden = true
            }else if selectTypeName == "安全监控分站故障" {
                cell.label1.text = "分站名称: \(model.StationName)"
                cell.label2.text = "分站编号: \(model.StationCode)"
                cell.label3.text = "分站位置: \(model.Place)"
                cell.label4.isHidden = true
                cell.label5.isHidden = true
            }else if selectTypeName == "安全监控传感器故障" {
                cell.label1.text = "传感器名称: \(model.SensorName)"
                cell.label2.text = "传感器编号: \(model.SensorNum)"
                cell.label3.text = "传感器位置: \(model.Place)"
                cell.label4.text = "值: \(model.Value ?? 0)"
                cell.label5.text = "单位: \(model.unit )"
            }else if selectTypeName == "断电" {
                cell.label1.text = "传感器编号: \(model.SensorNum)"
                cell.label2.text = "传感器位置: \(model.Place)"
                cell.label3.text = "值: \(model.Value ?? 0)"
                cell.label4.text = "单位: \(model.unit )"
                cell.label5.isHidden = true
            }else{
                cell.label1.text = "传感器名称: \(model.SensorName)"
                cell.label2.text = "传感器编号: \(model.SensorNum)"
                cell.label3.text = "传感器位置: \(model.Place)"
                cell.label4.text = "值: \(model.Value ?? 0)"
                cell.label5.text = "单位: \(model.unit )"
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(tableView.tag == 1001 ){
            let model = mHomeWaringTypeList[indexPath.row]
            selectTypeName = model.typeName ?? ""
            tableView.reloadData()
            showRightView()
            self.rightTableView.mj_header.beginRefreshing()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(tableView.tag == 1001) {
            return 50
        }else{
            if selectTypeName == "矿井超时" {
                return 95
            }else if selectTypeName == "区域超时" {
                return 115
            }else if selectTypeName == "区域超员" {
                return 115
            }else if selectTypeName == "人员定位分站故障" {
                return 75
            }else if selectTypeName == "安全监控分站故障" {
                return 95
            }else if selectTypeName == "安全监控传感器故障" {
                return 115
            }else if selectTypeName == "断电" {
                return 115
            }else{
                return 115
            }
        }
    }
    
}

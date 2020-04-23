//
//  Kj70HistoryListController.swift
//  ShineApp
//
//  Created by jiang.123 on 2020/4/9.
//  Copyright © 2020 jiang.123. All rights reserved.
//

import UIKit
import MJRefresh
private let HEAD_VIEW_HEIGHT = 0

private var mModelList : [KJ70HistoryDataModel] = [KJ70HistoryDataModel]()
private var noDataView : ListStateView = ListStateView()
class Kj70HistoryListController: UIViewController {
    var beginDate : String!
    var endDate : String!
    var mDeviceType : String!
    var mSensor : String!
    var searchTitle : String!
    private var CellStr : String = "HistoryWaringCell"
    var mUrl = "GetKj70HisAlarmInfo"
    var tableview:UITableView!
    var pageIndex = 0
    var mPageSize = 50
    private lazy var myViewModel : HistoryRequestModel = HistoryRequestModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        mModelList.removeAll()
    }
    
    func  initView(){
        self.view.backgroundColor = mainColor
        self.navigationItem.title = searchTitle
        tableview = UITableView(frame: CGRect(x: 0, y: HEAD_VIEW_HEIGHT, width: Int(mScreenW), height: Int(mScreenH) - HEAD_VIEW_HEIGHT  - Int(navigationBarHeight)))
        tableview.delegate = self
        tableview.dataSource = self
        tableview.tag = 1001
        tableview.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableview.backgroundColor = mainColor
        if searchTitle == "历史报警"{
            CellStr = "HistoryWaringCell"
            mUrl =  "GetKj70HisAlarmInfo"
        }else if searchTitle == "历史预警" {
            mUrl =  "GetKj70HisWarnAlarmNewInfo"
        }else if searchTitle == "历史设备故障" {
            mUrl =  "GetKj70HisFaultInfo"
            CellStr = "HistoryWaringCell"
        }else if searchTitle == "历史断电" {
            mUrl =  "GetKj70HisOutageInfo"
        }else if searchTitle == "历史模拟量" {
            mUrl =  "GetKj70HisSimulatesMinuteInfo"
        }else{
            mUrl =  "GetKj70HisSwitchChangeInfo"
        }
        tableview.register(UINib(nibName: CellStr, bundle: nil), forCellReuseIdentifier: CellStr)
        
        self.view.addSubview(tableview)
        noDataView.frame = CGRect(x: 0, y: HEAD_VIEW_HEIGHT, width: Int(mScreenW), height: Int(mScreenH) - HEAD_VIEW_HEIGHT - cvTopNavHeight - Int(navigationBarHeight))
        noDataView.isHidden = true
        self.view.addSubview(noDataView)
        //           let headView : UIView  = UIView()
        //           headView.frame = CGRect(x: 0, y: 0, width: Int(mScreenW), height: HEAD_VIEW_HEIGHT)
        //           headView.backgroundColor = mainColor
        //           self.view.addSubview(headView)
        //
        //           countLabel.frame = CGRect(x: 15, y: 0, width: 120, height: HEAD_VIEW_HEIGHT)
        //           countLabel.font = UIFont.systemFont(ofSize: 12)
        //           countLabel.textColor = UIColor.white
        //           countLabel.textAlignment = .left
        //           headView.addSubview(countLabel)
        //           self.view.addSubview(tableView)
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
//        header?.stateLabel.textColor = UIColor.white
        header?.lastUpdatedTimeLabel.isHidden = true
        // 3.设置tableview的header
        self.tableview.mj_header = header
        //4设置下拉刷新 放到加载完数据之后t加入
        
        // 5.开始刷新
        self.tableview.mj_header.beginRefreshing()
    }
    
    func addFooter(){
        let footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(getMoreData))
        footer?.setTitle("上拉加载更多", for: .idle)
        footer?.setTitle("没有更多数据", for: .noMoreData)
        self.tableview.mj_footer = footer
    }
    
    @objc func getData(){
        pageIndex = 0
        //获取数据
        myViewModel.requestHistoryData(url: mUrl, beginTime: beginDate, endTime: endDate,index: pageIndex,pageSize: mPageSize, typeCode: mDeviceType, sensornum: mSensor) {
            mModelList.removeAll()
            if self.myViewModel.historyDataModels.count > 0 {
                mModelList = self.myViewModel.historyDataModels
                noDataView.isHidden = true
            }else{
                noDataView.isHidden = false
            }
            if self.myViewModel.historyDataCount > self.myViewModel.historyDataModels.count {
                if self.tableview.mj_footer == nil {
                    self.addFooter()
                }
            }
           
            self.tableview.mj_header.endRefreshing()
            if(self.tableview.mj_footer != nil){
                 self.tableview.mj_footer.endRefreshing()
            }
            self.tableview.reloadData()
        }
    }
    @objc func getMoreData(){
        pageIndex += mPageSize
        //获取数据
        myViewModel.requestHistoryData(url: mUrl, beginTime: beginDate, endTime: endDate,index: pageIndex,pageSize: mPageSize, typeCode: mDeviceType, sensornum: mSensor) {
            mModelList.removeAll()
            
            if self.pageIndex != 0 && self.myViewModel.historyDataCount == self.myViewModel.historyDataModels.count {
                self.pageIndex  = self.myViewModel.historyDataCount
   
                self.tableview.mj_footer.endRefreshingWithNoMoreData()
            }else{
                
                if self.myViewModel.historyDataModels.count > 0 {
                    mModelList = self.myViewModel.historyDataModels

                }else{
                }
                self.tableview.mj_footer.endRefreshing()
                //这边需判断没有更多数据的情况
                self.tableview.reloadData()
                
            }
        }
    }
}

extension Kj70HistoryListController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mModelList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellStr,for: indexPath) as! HistoryWaringCell
        let model = mModelList[indexPath.row]
        
        if searchTitle == "历史报警"{
            cell.placelabel.text = "\(model.Place ?? "无")"
            cell.waringStatelabel.text = model.TypeName
            cell.sensorNumLabel.text = "\(model.SensorNum ?? "无")"
            cell.valLabel.text = "值: " +  model.AlarmValue
            cell.typeLabel.text = model.alarmtype
            cell.beginTimeLabel.text = "开始时间: " + model.PoliceDatetime
            cell.endTimeLabel.text = "结束时间: " + model.PoliceEndDatetime
            cell.contiousLabel.text = "持续时间: " + model.continuoustime
        }else if searchTitle == "历史预警" {
            
            cell.placelabel.text =  "\(model.SimpleName ?? "") \(model.Place ?? "")"
            cell.sensorNumLabel.text = "\(model.SensorNum ?? "无")"
            cell.valLabel.text = "\(model.Value ?? 0)"
            cell.beginTimeLabel.text = model.BeginTime
            cell.typeLabel.isHidden = true
            cell.endTimeLabel.isHidden = true
            cell.contiousLabel.isHidden = true
            cell.waringStatelabel.isHidden = true
            
        }else if searchTitle == "历史设备故障" {
            cell.placelabel.text = "\(model.Place ?? "无")"
            cell.waringStatelabel.text = model.TypeName == nil ? "" : model.TypeName
            cell.sensorNumLabel.text = "\(model.SensorNum ?? "无")"
            cell.valLabel.text = "原因: " +  model.FaultCause
            cell.typeLabel.isHidden = true
            cell.beginTimeLabel.text = "故障时间: " + model.HitchDatetime
            cell.endTimeLabel.text = "结束时间: " + model.HitchEndDatetime
            cell.contiousLabel.text = "持续时间: " + model.continuoustime
        }else if searchTitle == "历史断电" {
            cell.placelabel.text = "\(model.Place ?? "无")"
            cell.waringStatelabel.text = model.TypeName == nil ? "" : model.TypeName
            cell.sensorNumLabel.text = "\(model.SensorNum ?? "无")"
            cell.valLabel.text = "值: \(model.max ?? 0)"
            cell.typeLabel.text = model.powertype
            cell.beginTimeLabel.text = "断电时间: " + model.PowerDatetime
            cell.endTimeLabel.text = "结束时间: " + model.PowerEndDatetime
            cell.contiousLabel.text = "持续时间: " + model.continuoustime
        }else if searchTitle == "历史模拟量" {
            cell.placelabel.text = "\(model.Place ?? "无")"
            cell.waringStatelabel.text = model.TypeName == nil ? "" : model.TypeName
            cell.sensorNumLabel.text = "平均值: \(model.StatisticaAvg ?? 0)" 
            cell.valLabel.text = "最大值: \( model.StatisticaMaxValue ?? 0)"
            cell.typeLabel.text = "最小值: \( model.StatisticaMinValue ?? 0)"
            cell.beginTimeLabel.text = "平均值时间: " + model.StatisticalTime
            cell.endTimeLabel.text = "最大值时间: " + model.StatisticaMaxDatetime
            cell.contiousLabel.text = "最小值时间: " + model.StatisticaMinDatetime
        }else{
            cell.placelabel.text = "\(model.Place ?? "无")"
            cell.waringStatelabel.text = model.TypeName
            cell.sensorNumLabel.text = "\(model.SensorNum ?? "无")"
            let stateStr = model.State
            cell.valLabel.text = stateStr
                  switch stateStr {
                  case "报警状态":
                      cell.valLabel.textColor = waringColor
                      break
                  case "工作状态":cell.valLabel.textColor = successColor
                      break
                  case "故障状态":cell.valLabel.textColor = errorColor
                      break
                  default:cell.valLabel.textColor = errorColor
                      break
                  }

            cell.beginTimeLabel.text = model.StateDatetime
            cell.typeLabel.isHidden = true
            cell.endTimeLabel.isHidden = true
            cell.contiousLabel.isHidden = true
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if searchTitle == "历史报警"{
            return 120
        }else if searchTitle == "历史预警" {
            return 75
        }else if searchTitle == "历史设备故障" {
            return 120
        }else if searchTitle == "历史断电" {
            return 120
        }else if searchTitle == "历史模拟量" {
            return 120
        }else{
            return 75
        }
    }
}

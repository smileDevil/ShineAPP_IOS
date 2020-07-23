//
//  KJ128HistoryDataListVC.swift
//  ShineApp
//
//  Created by jiang.123 on 2020/5/13.
//  Copyright © 2020 jiang.123. All rights reserved.
//

import UIKit
import MJRefresh
private let HEAD_VIEW_HEIGHT = 0
private var mModelList : [KJ128HistoryDataModel] = [KJ128HistoryDataModel]()
private var noDataView : ListStateView = ListStateView()
private var CellStr : String = "KJ128HistoryCell"

class KJ128HistoryDataListVC: UIViewController {
    var beginDate : String!
    var endDate : String!
    var searchTitle : String!
    var jobCardCode:String!
    var mUrl = "GetKj128HisInMineTime"
    var tableview:UITableView!
    var pageIndex = 0
    var mPageSize = 50
    private lazy var myViewModel : KJ128HistoryViewModel = KJ128HistoryViewModel()
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        mModelList.removeAll()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = mainColor
        self.navigationItem.title = searchTitle
        tableview = UITableView(frame: CGRect(x: 0, y: HEAD_VIEW_HEIGHT, width: Int(mScreenW), height: Int(mScreenH) - HEAD_VIEW_HEIGHT  - Int(navigationBarHeight)))
        tableview.delegate = self
        tableview.dataSource = self
        tableview.tag = 1001
        tableview.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableview.backgroundColor = mainColor
        tableview.register(UINib(nibName: CellStr, bundle: nil), forCellReuseIdentifier: CellStr)
        self.view.addSubview(tableview)
        noDataView.frame = CGRect(x: 0, y: HEAD_VIEW_HEIGHT, width: Int(mScreenW), height: Int(mScreenH) - HEAD_VIEW_HEIGHT - cvTopNavHeight - Int(navigationBarHeight))
        noDataView.isHidden = true
        self.view.addSubview(noDataView)
        if searchTitle == "历史井下时间" {
            mUrl = "GetKj128HisInMineTime"
        }else if searchTitle == "历史超时报警" {
            mUrl = "GetKj128HisOvertimeAlarm"
        }else if searchTitle == "历史超员报警" {
            mUrl = "GetKj128HisOvermanReport"
        }else if searchTitle == "历史超员/限制区域报警" {
            mUrl = "GetKj128HisOvermanRestrictedAreaAlarm"
        }else if searchTitle == "历史求救报警" {
            mUrl = "GetKj128HisHelpAlarm"
        }else if searchTitle == "历史分站状态" {
            mUrl = "GetKj128HisSubStation"
        }else if searchTitle == "历史区域信息" {
            mUrl = "GetKj128HisAreaInfo"
        }else {
            mUrl = "GetKj128HisCheckAttendance"
        }
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
        myViewModel.getKJ128HistoryDataLists(url: mUrl, beginTime: beginDate, endTime: endDate, jobCardCode: jobCardCode, index: pageIndex, pageSize: mPageSize) {
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
        myViewModel.getKJ128HistoryDataLists(url: mUrl, beginTime: beginDate, endTime: endDate, jobCardCode: jobCardCode, index: pageIndex, pageSize: mPageSize) {
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

extension KJ128HistoryDataListVC : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mModelList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellStr,for: indexPath) as! KJ128HistoryCell
        let model = mModelList[indexPath.row]
        if searchTitle == "历史井下时间" {
            cell.label1.text = "煤矿名称: \(model.SimpleName ?? "")"
            cell.label2bgView.isHidden = true
            cell.label3.text = "姓名: \(model.Name ?? "")"
            cell.label4.text = "职位: \(model.Department ?? "")"
            cell.label5.isHidden = true
            cell.label6.text = "入井时间: \(model.InTime ?? "")"
            cell.label7.text = "出井时间: \(model.OutTime ?? "")"
            cell.label8.text = "持续时间: \(model.Duration )分钟"
            
        }else if searchTitle == "历史超时报警" {
            cell.label1.text = "所在区域: \(model.AreaName ?? "")\(model.AreaType ?? "")"
            cell.label2titleLabel.text = "所在部门:"
            cell.label2.text = " \(model.Department ?? "")"
            cell.label3.text = "姓名: \(model.Name ?? "")"
            cell.label4.text = "卡号: \(model.JobCardCode ?? "")"
            cell.label5.text = "职位: \(model.Position ?? "")"
            cell.label6.text = "报警开始时间: \(model.StartAlTime ?? "")"
            cell.label7.text = "报警结束时间: \(model.EndAlTime ?? "")"
            cell.label8.text = "报警时长: \(model.AlarmTime ?? "")分钟"
        }else if searchTitle == "历史超员报警" {
            cell.label1.text = "所在区域: \(model.AreaName ?? ""))"
            cell.label2bgView.isHidden = true
            cell.label3.text = "总人数: \(model.Number ?? 0)"
            cell.label4.text = "超员人数: \(model.OvermanNum ?? "")"
            cell.label5.isHidden = true
            cell.label6.text = "报警开始时间: \(model.StartAlTime ?? "")"
            cell.label7.text = "报警结束时间: \(model.EndAlTime ?? "")"
            cell.label8.text = "报警时长: \(model.AlarmTime ?? "")分钟"
        }else if searchTitle == "历史超员/限制区域报警" {
            cell.label1.text = "所在区域: \(model.AreaName ?? "")\(model.StationName ?? "")"
            cell.label2titleLabel.text = "报警类型:"
            cell.label2.text = " \(model.Type ?? "")"
            cell.label3.text = "定员数: \(model.Number ?? 0)"
            cell.label4.text = "总人数: \(model.Sum ?? 0)"
            cell.label5.text = "分站人数: \(model.StationSum ?? 0)"
            cell.label6.text = "报警开始时间: \(model.StartAlTime ?? "")"
            cell.label7.text = "报警结束时间: \(model.EndAlTime ?? "")"
            cell.label8.text = "报警时长: \(model.AlarmTime ?? "")分钟"
        }else if searchTitle == "历史求救报警" {
            cell.label1.text = "姓名: \(model.Name ?? ""))"
             cell.label2titleLabel.text = "职位:"
            cell.label2.text = " \(model.Position ?? "")"
            cell.label3.text = "卡号: \(model.JobCardCode ?? "")"
            cell.label4.text = "部门: \(model.Department ?? "")"
            cell.label5.isHidden = true
            cell.label6.text = "求救开始时间: \(model.StartHelpTime ?? "")"
            cell.label7.text = "求救结束时间: \(model.EndHelpTime ?? "")"
            cell.label8.text = "求救时长: \(model.Duration )分钟"
            
        }else if searchTitle == "历史分站状态" {
            cell.label1.text = "\(model.StationName ?? "") \(model.Place ?? "")"
             cell.label2bgView.isHidden = true
            cell.label3.text = "分站编号: \(model.StationCode ?? "")"
            cell.label4.text = "状态: \(model.StationState ?? "")"
            cell.label5.isHidden = true
            cell.label6.text = "开始时间: \(model.StartAlTime ?? "")"
            cell.label7.text = "结束时间: \(model.EndAlTime ?? "")"
            cell.label8.text = "持续时间: \(model.AlarmTime ?? "")分钟"
        }else if searchTitle == "历史区域信息" {
            cell.label1.text = "所在区域: \(model.AreaName ?? "")"
             cell.label2titleLabel.text = "所在部门:"
            cell.label2.text = " \(model.Department ?? "")"
            cell.label3.text = "姓名: \(model.Name ?? "")"
            cell.label4.text = "卡号: \(model.JobCardCode ?? "")"
            cell.label5.text = "职位: \(model.Position ?? "")"
            cell.label6.text = "进入时间: \(model.InAreaTime ?? "")"
            cell.label7.text = "出去时间: \(model.OutAreaTime ?? "")"
            cell.label8.text = "持续时间: \(model.Duration)分钟"
        }else {
            cell.label1.text = "班次: \(model.Class ?? "")"
             cell.label2titleLabel.text = "出入状态:"
            cell.label2.text = " \(model.InOutType ?? "")"
            cell.label3.text = "姓名: \(model.Name ?? "")"
            cell.label4.text = "卡号: \(model.JobCardCode ?? "")"
            cell.label5.text = "职位: \(model.Position ?? "")"
            cell.label6.text = "进入时间: \(model.InTime ?? "")"
            cell.label7.text = "出去时间: \(model.OutTime ?? "")"
            cell.label8.text = "工作时长: \(model.WorkingHours ?? 0)分钟"

        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if searchTitle == "历史井下时间" {
            return 120
        }else if searchTitle == "历史超时报警" {
            return 120
        }else if searchTitle == "历史超员报警" {
            return 120
        }else if searchTitle == "历史超员/限制区域报警" {
            return 120
        }else if searchTitle == "历史求救报警" {
            return 120
        }else if searchTitle == "历史分站状态" {
            return 120
        }else if searchTitle == "历史区域信息" {
            return 120
        }else {
            return 120
        }
    }
}

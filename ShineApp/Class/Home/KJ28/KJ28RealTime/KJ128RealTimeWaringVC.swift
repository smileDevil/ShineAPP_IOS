//
//  KJ128RealTimeWaringVC.swift
//  ShineApp
//
//  Created by jiang.123 on 2020/4/21.
//  Copyright © 2020 jiang.123. All rights reserved.
//

import UIKit
import MJRefresh
private let HEAD_VIEW_HEIGHT = 40
private let CellStr : String = "KJ128RealTimeWaringCell"
private let typeCellStr = "TypeViewCell"
private var mModelList : [KJ128RealTimeWaringModel] = [KJ128RealTimeWaringModel]()
private var mUrl : String =  "GetKj128RTOverTimeInfo"
private var mTypName : String = ""
class KJ128RealTimeWaringVC: UIViewController {
    private lazy var myViewModel : Kj128RealTimeViewModel = Kj128RealTimeViewModel()
    private lazy var sensorNameTypeArr : [String] = [String]()
    private lazy var sensorTypeArr : [KJ70DeviceTypeModel] = [KJ70DeviceTypeModel]()
    private let typeNameArr : [String] = ["超时报警","超员报警","区域报警"]
    private var typeBtn  : UIButton!
    private var noDataView : ListStateView = ListStateView()
    
    fileprivate lazy var typeTableView : UITableView  = {
        let tableview = UITableView(frame: CGRect(x: 10, y: HEAD_VIEW_HEIGHT, width: 60, height: 90))
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
        self.view.backgroundColor = mainColor
        initView()
    }
    
}

extension KJ128RealTimeWaringVC {
    func  initView(){
        self.view.backgroundColor = mainColor
        let headView : UIView  = UIView()
        headView.frame = CGRect(x: 0, y: 0, width: Int(mScreenW), height: HEAD_VIEW_HEIGHT)
        headView.backgroundColor = mainColor
        self.view.addSubview(headView)
        
        typeBtn = UIButton(frame: CGRect(x: 10, y: 0, width: 60, height: HEAD_VIEW_HEIGHT))
        typeBtn.addTarget(self, action: #selector(showTypeSelect), for: .touchUpInside)
        typeBtn.setTitle("超时报警", for: .normal)
        typeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        typeBtn.titleLabel?.textAlignment = .left
        headView.addSubview(typeBtn)
        
        let arrowDownImagVew = UIImageView(frame: CGRect(x: typeBtn.frame.width + typeBtn.frame.origin.x  + 5, y: 10, width: 20, height: 20))
        arrowDownImagVew.image = UIImage(named: "arrow_down.png")
        headView.addSubview(arrowDownImagVew)
         self.view.addSubview(tableView)
        noDataView.frame = CGRect(x: 0, y: HEAD_VIEW_HEIGHT, width: Int(mScreenW), height: Int(mScreenH) - HEAD_VIEW_HEIGHT - cvTopNavHeight - Int(navigationBarHeight))
                noDataView.isHidden = true
                self.view.addSubview(noDataView)
         self.view.addSubview(typeTableView)
        setRefresh()
    }
    
    //打开x下来选择
    @objc func showTypeSelect(){
        typeTableView.isHidden = !typeTableView.isHidden
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
        myViewModel.request128Waring(url: mUrl) {
            mModelList.removeAll()
            if self.myViewModel.realTimeWaringModels.count > 0 {
                mModelList = self.myViewModel.realTimeWaringModels
                self.noDataView.isHidden = true
            }else{
                self.noDataView.isHidden = false
            }
            self.tableView.mj_header.endRefreshing()
            self.tableView.reloadData()
        }
    }
}

extension KJ128RealTimeWaringVC : UITableViewDelegate,UITableViewDataSource {
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
            let cell = tableView.dequeueReusableCell(withIdentifier: CellStr,for: indexPath) as! KJ128RealTimeWaringCell
            let model = mModelList[indexPath.row]
            cell.minelabel.text = "矿区: \(model.SimpleName ?? "")"
            cell.nameLabel.text = "姓名: \(model.Name ?? "")"
            cell.positionLabel.text = "职位: \(model.Position ?? "")"
            cell.jobcardLabel.text = "卡号: \(model.JobCardCode ?? "")"
            cell.departmentLabel.text = "部门: \(model.Department ?? "")"
          
            let areaName : String = model.AreaName ?? ""
            if areaName != "" {
                 cell.areaNameLabel.text = "区域: \(areaName)"
            }else{
                let Type  = model.Type ?? ""
                if Type != "" {
                     cell.areaNameLabel.text = "类型: \(Type)"
                }
            }
            cell.placeLabel.text = "位置: \(model.Place ?? "")"
            cell.beginTimelabel.text = "报警时间: \(model.StartAlTime ?? "")"
            cell.continuousLabel.text = "持续时间: \(model.continuoustime ?? "")"
            
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
            if typeName == "超时报警" {
                mUrl = "GetKj128RTOverTimeInfo"
            }else if typeName == "超员报警"{
                mUrl = "GetKj128RTOverManInfo"
            }else if typeName == "区域报警"{
                mUrl = "GetKj128RTRestrictedAreasInfo"
            }else  {
                mUrl = "GetKj128RTOverTimeInfo"
            }
            tableView.isHidden = true
            self.typeBtn.setTitle(typeName, for: .normal)
            self.tableView.mj_header.beginRefreshing()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(tableView.tag == 1001) {
            return 135
        }else{
            return 30
        }
    }
    
}

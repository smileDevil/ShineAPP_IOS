//
//  OpOutController.swift
//  ShineApp
//
//  Created by jiang.123 on 2020/3/25.
//  Copyright © 2020 jiang.123. All rights reserved.
//

import UIKit
import MJRefresh
private let HEAD_VIEW_HEIGHT = 40
private let CellStr : String = "RealTimeOpenOutCell"
private var mModelList : [RealTimeOpenOutModel] = [RealTimeOpenOutModel]()
private var countLabel : UILabel = UILabel()
class OpOutController: BaseViewController {
    private lazy var myViewModel : RealTimeRequestModel = RealTimeRequestModel()
      private var noDataView : ListStateView = ListStateView()
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
        
        self.view.addSubview(tableView)
        
        noDataView.frame = CGRect(x: 0, y: HEAD_VIEW_HEIGHT, width: Int(mScreenW), height: Int(mScreenH) - HEAD_VIEW_HEIGHT - cvTopNavHeight - Int(navigationBarHeight))
                   noDataView.isHidden = true
                   self.view.addSubview(noDataView)
        setRefresh()
    }
    
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
          myViewModel.requestOpenoutData {
              countLabel.text = "总数:\(self.myViewModel.openoutCount)条"
              
              mModelList.removeAll()
              if self.myViewModel.openoutCount > 0 {
                  mModelList = self.myViewModel.realTimeOpenOutModels
             self.noDataView.isHidden = true
                                  }else{
                  self.noDataView.isHidden = false
                                }
            self.tableView.mj_header.endRefreshing()
              self.tableView.reloadData()
          }
        
    }
}

extension OpOutController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return mModelList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellStr,for: indexPath) as! RealTimeOpenOutCell
        let model = mModelList[indexPath.row]
        cell.placeLabel.text = "地点: \(model.Place)"
        let stateStr = model.state
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
        cell.stateLabel.text = model.state
        cell.numLabel.text = "编号: \(model.SensorNum)"
        cell.dateLabel.text = "时间: \(model.Datetime)"
        cell.typeNameLabel.text = "名称: \(model.TypeName)"
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
        
    }
}


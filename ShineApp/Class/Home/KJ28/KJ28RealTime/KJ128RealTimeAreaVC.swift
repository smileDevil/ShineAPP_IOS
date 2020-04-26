//
//  KJ128RealTimeAreaVC.swift
//  ShineApp
//
//  Created by jiang.123 on 2020/4/21.
//  Copyright © 2020 jiang.123. All rights reserved.
//

import UIKit
import MJRefresh
private let HEAD_VIEW_HEIGHT = 40
private let CellStr : String = "KJ128BaseCell"
private var mModelList : [KJ128RealTimeAreaInfoModel] = [KJ128RealTimeAreaInfoModel]()
private var countLabel : UILabel = UILabel()
private var noDataView : ListStateView = ListStateView()

class KJ128RealTimeAreaVC: UIViewController {
    private lazy var myViewModel : Kj128RealTimeViewModel = Kj128RealTimeViewModel()
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
      myViewModel.request128AreaInfo{
            countLabel.text = "总数:\(self.myViewModel.areaInfoCount)条"
            mModelList.removeAll()
            if self.myViewModel.areaInfoCount > 0 {
                mModelList = self.myViewModel.realTimeAreaInfoModels
                noDataView.isHidden = true
            }else{
                noDataView.isHidden = false
            }
            self.tableView.mj_header.endRefreshing()
            self.tableView.reloadData()
        }
    }

}

extension KJ128RealTimeAreaVC : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return mModelList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellStr,for: indexPath) as! KJ128BaseCell
        let model = mModelList[indexPath.row]
        cell.baseLabelOne.text = "所属煤矿: \(model.SimpleName ?? "")"
        cell.baseLabelTwo.text =  "所属城市: \(model.City ?? "")"
        cell.baseLabelThr.text =  "区域类型: \(model.AreaType ?? "")"
        cell.baseLabelfor.text =  "区域名称: \(model.AreaName ?? "")"
        cell.baseLabelFiv.text =  "员工数量: \(model.Workers)人"
        cell.baseSixView.isHidden = true
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}


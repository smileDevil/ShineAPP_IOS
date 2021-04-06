//
//  NotificationViewController.swift
//  ShineApp
//
//  Created by jiang.123 on 2020/12/19.
//  Copyright © 2020 jiang.123. All rights reserved.
//

import UIKit
import MJRefresh
private let CellStr : String = "NotificationCell"
private let HEAD_VIEW_HEIGHT = 40
class NotificationViewController: BaseViewController {
    //没有数据界面
    private var noDataView : ListStateView = ListStateView()
    var datePicker:UIDatePicker!
    var pickerBottomView : UIView!
    var dismissView :UIView!
    private var mCountLabel : UILabel = UILabel()
    private var rowStart : Int = 0
    private var rowSize : Int = 100
    private var startTime : String  = ""
    private var mNotificationList:[NotificationModel] = [NotificationModel]()
    private lazy var homeViewModel : HomeWaringViewModel = HomeWaringViewModel()
    fileprivate lazy var tableView : UITableView  = {
        let tableview = UITableView(frame: CGRect(x: 0, y: HEAD_VIEW_HEIGHT, width: Int(mScreenW), height: Int(mScreenH) - HEAD_VIEW_HEIGHT - Int(navigationBarHeight)))
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
        self.navigationItem.title = "我的通知"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "", style: .done, target: self, action: #selector(createPickView))
        self.navigationItem.rightBarButtonItem?.tintColor = .white
        getNowDate()
        
        mCountLabel = UILabel(frame: CGRect(x: 15, y: 0, width: 100, height: HEAD_VIEW_HEIGHT))
        mCountLabel.text = ""
        mCountLabel.font = smallTitleFontSize
        mCountLabel.textColor = .white
        self.view.addSubview(mCountLabel)
        
        noDataView.frame = CGRect(x: 0, y: 0, width: Int(mScreenW), height: Int(mScreenH) - HEAD_VIEW_HEIGHT - Int(navigationBarHeight))
        noDataView.isHidden = true
        
        self.view.addSubview(tableView)
        self.view.addSubview(noDataView)
        setRefresh()
    }
    
    
    //获取当前系统时间
    func getNowDate(){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let date  = Date()
        let nowDataStr = formatter.string(from: date)
        startTime = nowDataStr
        self.navigationItem.rightBarButtonItem?.title = nowDataStr
    }
    
    @objc func createPickView(){
        view.endEditing(true)
        dismissView = UIView(frame: CGRect(x: 0, y: 0, width: mScreenW, height: mScreenH))
        dismissView.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.35)
        dismissView.isUserInteractionEnabled = true
        let dismisTap = UITapGestureRecognizer(target: self, action: #selector(dismissTap))
        dismisTap.numberOfTapsRequired = 1
        dismissView.addGestureRecognizer(dismisTap)
        self.view.addSubview(dismissView)
        
        let pickH :CGFloat = 250
        pickerBottomView =  UIView(frame: CGRect(x: 0, y: mScreenH - navigationBarHeight - pickH  , width: mScreenW, height:pickH))
        pickerBottomView.backgroundColor = mainColor
        self.view.addSubview(pickerBottomView)
        
        let actionView =  UIView(frame: CGRect(x: 0, y:0, width: mScreenW, height:40))
        //           actionView.layer.borderColor =  UIColor.gray.cgColor
        //           actionView.layer.borderWidth = 0.5
        pickerBottomView.addSubview(actionView)
        
        let button = UIButton(frame:CGRect(x: mScreenW-100, y: 5, width: 90, height: 30))
        button.setTitleColor(.white, for: .normal)
        button.setTitle("确定", for: .normal)
        button.addTarget(self, action: #selector(getPickerViewValue), for: .touchUpInside)
        actionView.addSubview(button)
        
        
        datePicker = UIDatePicker(frame: CGRect(x: 0, y: 40, width: mScreenW, height:pickH-40))
        datePicker.locale = NSLocale(localeIdentifier: "zh_CN") as Locale
        datePicker.setValue(UIColor.white, forKey: "textColor")
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        datePicker.datePickerMode = .date
        pickerBottomView.addSubview(datePicker)
        
    }
    
    //时间改变监控
    @objc func dateChanged(){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let date = formatter.string(from: datePicker.date)
        startTime = date
        self.navigationItem.rightBarButtonItem?.title = date
    }
    //pickview 确定s事件,获取选中的值
    @objc func getPickerViewValue(){
        rowStart = 0
        getData()
        dismissTap()
    }
    
    //取消界面的pickview 和dismissView
    @objc func dismissTap(){
        UIView.animate(withDuration: 0.5, animations: {
            if(self.pickerBottomView != nil ){
                self.pickerBottomView.frame = CGRect(x: 0, y:mScreenH, width: mScreenW, height:0)
                self.dismissView.frame = CGRect(x: 0, y:mScreenH, width: mScreenW, height:0)
            }
        }) { (_) in
        }
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
        addFooter()
        // 4.开始刷新
        tableView.mj_header.beginRefreshing()
        
    }
    
    func addFooter(){
        let footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(getMoreData))
        footer?.setTitle("上拉加载更多", for: .idle)
        footer?.setTitle("没有更多数据", for: .noMoreData)
        tableView.mj_footer = footer
        tableView.mj_footer.isHidden = true
    }
    
    @objc func getData() {
        homeViewModel.requestMyNotificationData(startRow: rowStart, rowSize: rowSize, startTime: startTime) {
            self.mNotificationList.removeAll()
            if self.homeViewModel.mNotificationList.count > 0 {
                self.mNotificationList = self.homeViewModel.mNotificationList
                self.mCountLabel.text = "总计: \(self.homeViewModel.notificationCount)条"
                self.noDataView.isHidden = true
            }else{
                self.mCountLabel.text = "总计: 0条"
                self.noDataView.isHidden = false
            }
            if self.homeViewModel.notificationCount > self.homeViewModel.mNotificationList.count {
                self.tableView.mj_footer.isHidden = false
            }else{
                self.tableView.mj_footer.isHidden = true
            }
            self.tableView.mj_header.endRefreshing()
            self.tableView.reloadData()
        }
    }
    
    
    @objc func getMoreData(){
        rowSize += rowSize
        homeViewModel.requestMyNotificationData(startRow: rowStart, rowSize: rowSize, startTime: startTime) {
            self.mNotificationList.removeAll()
            if self.rowStart != 0 && self.homeViewModel.notificationCount ==  self.mNotificationList.count {
                self.rowStart  = self.rowStart - self.rowSize
                self.tableView.mj_footer.endRefreshingWithNoMoreData()
            }else{
                if self.homeViewModel.mNotificationList.count > 0 {
                    self.mNotificationList = self.homeViewModel.mNotificationList
                }else{
                    
                }
                self.tableView.mj_footer.endRefreshing()
                //这边需判断没有更多数据的情况
                self.tableView.reloadData()
            }
        }
    }
}

extension NotificationViewController : UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return mNotificationList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellStr,for: indexPath) as! NotificationCell
        let model = self.mNotificationList[indexPath.row]
        cell.labelTitle.text = "标题: \(model.PushTitle ?? "")"
        cell.labelContent.text = model.PushContent
        cell.labelState.text = model.PushState
        cell.labelTime.text = "推送时间: \(model.PushTime ?? "")"
        let lineHeight : CGFloat = heightOfCell(text: model.PushContent)
        cell.contentLineHeight.constant = lineHeight
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          let model = self.mNotificationList[indexPath.row]
          let lineHeight : CGFloat = heightOfCell(text: model.PushContent)
        return 75 + lineHeight - 15
    }
    
    func heightOfCell(text : String) -> CGFloat {
        let attributes = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 12)]
        let option = NSStringDrawingOptions.usesLineFragmentOrigin
        let rect:CGRect = text.boundingRect(with: CGSize(width: mScreenW - 80, height: 0), options: option, attributes: attributes, context: nil)
          print("height is \(rect.size.height)")
          return rect.size.height
      }
    
}


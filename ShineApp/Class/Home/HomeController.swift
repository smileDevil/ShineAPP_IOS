//
//  HomeController.swift
//  ShineApp
//
//  Created by jiang.123 on 2020/3/21.
//  Copyright © 2020 jiang.123. All rights reserved.
//

import UIKit

private var mTypeBtnViews : UIView  = UIView()

private let normalTypeImages : [String] = ["save_main","people_main","gb_main","ky_main","video_main","fs_main"]

private let touchTypeImages : [String] = ["save_main_selected","people_main_selected","gb_main_selected","ky_main_selected","video_main_selected","fs_main_selected"]

private let typeTitles : [String] = ["安全监控","人员定位","调度广播","爆炸感知","瓦斯抽放","视频监控"]

class HomeController: BaseViewController {
    
    var pickerView:UIPickerView!
    var pickerBottomView : UIView!
    var dismissView :UIView!
    var navTitView : NavTitleView = NavTitleView()
    var mHeadView : UIView!
    var mWaringTitleView : HomeTitleVIew!
    var mWaringView : UIView!
    fileprivate var mineArr:[MineModel] = [MineModel]()
    private var mHomeWaringStaticModel : HomeWaringStataicsModel?
    private var mWaringMsgList : [String] = [String]()
    
    private lazy var myViewModel : RealTimeRequestModel = RealTimeRequestModel()
    private lazy var homeViewModel : HomeWaringViewModel = HomeWaringViewModel()
    //懒加载创建tableview
    fileprivate lazy var tableView : UITableView = {[weak self] in
        //         let tableView = UITableView(frame:CGRect(x: 0, y: 0, width: mScreenW, height: mScreenH - tabBarHeight - navigationBarHeight))
        let tableView = UITableView(frame:CGRect(x: 0, y: 0, width: mScreenW, height: mScreenH  - navigationBarHeight))
        tableView.backgroundColor = mainColor
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        return tableView;
        }()
    
    fileprivate lazy var cycleView : RecommendCycieView = {
        let cycleview = RecommendCycieView.recommendCycleViewe()
        cycleview.frame = CGRect(x: jCycleViewMargin, y: jCycleViewMarginTop, width: (Int(mScreenW - (CGFloat)(jCycleViewMargin * 2))), height: jCycleViewH)
        return cycleview
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "通知", style: .done, target: self, action: #selector(gotoNotifictaion))
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        
        //UpdateManager.init()
        initViews()
        loadData()
    }
    
    @objc func gotoNotifictaion(){
        self.navigationController?.pushViewController(NotificationViewController(), animated: true)
    }
}

extension HomeController{
    func initViews(){
        navTitView = NavTitleView(frame: CGRect(x: 0, y: 0, width: 140, height: cvTopNavHeight))
        navTitView.titleBtn?.addTarget(self, action: #selector(chooseMine), for: .touchUpInside)
        self.navigationItem.titleView = navTitView
        let mineName =  UserDefaults.standard.string(forKey: "mineName")
        navTitView.titleBtn?.setTitle(mineName, for: .normal)
        self.view.addSubview(tableView)
        
        //        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "分享", style: .done, target: self, action: #selector(shareAction))
        
        let HeadView = UIView()
        mHeadView = HeadView
        HeadView.backgroundColor = mainColor
        HeadView.addSubview(cycleView)
        //        tableView.contentInset = UIEdgeInsets(top: CGFloat(jCycleViewH), left: 0, bottom: 0, right: 0 )
        
        let typeBtnViews = UIView()
        mTypeBtnViews = typeBtnViews
        
        let btnW  = 137
        let btnH = 85
        // let rowMargin = (Int(mScreenW) - btnW * 1 ) / 2
        let rowMargin = (Int(mScreenW) - btnW * 2 ) / 3
        let secMargin = isIphoneX ? 30 : 15
        let showNum = 1 // 显示的模块数量
        for i in 0...showNum {
            let sec = i / 2
            let row = i % 2
            let btnX = rowMargin + row * (btnW + rowMargin)
            let btnY = (btnH + secMargin)  * sec
            
            let tybtnView = TypeButtonView()
            tybtnView.frame = CGRect(x: btnX, y: btnY, width: btnW, height: btnH)
            tybtnView.typeTitleLabel.text = typeTitles[i]
            tybtnView.typelogImg.image = UIImage(named: normalTypeImages[i])
            tybtnView.typeClickBtn.tag = i
            tybtnView.typeClickBtn.addTarget(self, action: #selector(touchDown), for: .touchDown)
            tybtnView.typeClickBtn.addTarget(self, action: #selector(touchUpInside), for: .touchUpInside)
            tybtnView.typeClickBtn.addTarget(self, action: #selector(touchUpOutside), for: .touchUpOutside)
            typeBtnViews.addSubview(tybtnView)
            if i == showNum {
                typeBtnViews.frame = CGRect(x: 0, y: Int(jCycleViewH + jCycleTopMargin + typeViewMarginCycleView), width: Int(mScreenW), height:  Int(btnY + btnH + 20))
            }
        }
        HeadView.addSubview(typeBtnViews)
        HeadView.frame = CGRect(x: 0, y: 0, width: Int(mScreenW), height: jCycleViewH + jCycleTopMargin + typeViewMarginCycleView + Int(typeBtnViews.frame.size.height) )
        
        
        
        tableView.addSubview(mHeadView)
    }
    
    //分享
    @objc func shareAction (){
        
        
    }
    //架子啊数据
    func loadData(){
        myViewModel.getMineList {
            self.mineArr.removeAll()
            if self.myViewModel.mineModelList.count > 0{
                self.mineArr = self.myViewModel.mineModelList;
            }
        }
        
        homeViewModel.requestHomeWaringListData {
            self.mHomeWaringStaticModel = self.homeViewModel.mHomeWaringModel
            self.doHomeStaticsAction()
        }
    }
    
    func doHomeStaticsAction(){
        if(self.mHomeWaringStaticModel == nil){
            return
        }
        mWaringMsgList.removeAll()
        if(mHomeWaringStaticModel?.矿井超时 != nil){
            mWaringMsgList.append("矿井超时: \(mHomeWaringStaticModel?.矿井超时 ?? "")")
        }
        if(mHomeWaringStaticModel?.矿井超员 != nil){
            mWaringMsgList.append("矿井超员: \(mHomeWaringStaticModel?.矿井超员 ?? "")")
        }
        if(mHomeWaringStaticModel?.区域超时 != nil){
            mWaringMsgList.append("区域超时: \(mHomeWaringStaticModel?.区域超时 ?? "")")
        }
        if(mHomeWaringStaticModel?.区域超员 != nil){
            mWaringMsgList.append("区域超员: \(mHomeWaringStaticModel?.区域超员 ?? "")")
        }
        if(mHomeWaringStaticModel?.人员定位分站故障 != nil){
            mWaringMsgList.append("人员定位分站故障: \(mHomeWaringStaticModel?.人员定位分站故障 ?? "")")
        }
        if(mHomeWaringStaticModel?.安全监控传感器故障 != nil){
            mWaringMsgList.append("安全监控传感器故障: \(mHomeWaringStaticModel?.安全监控传感器故障 ?? "")")
        }
        if(mHomeWaringStaticModel?.安全监控分站故障 != nil){
            mWaringMsgList.append("安全监控分站故障: \(mHomeWaringStaticModel?.安全监控分站故障 ?? "")")
        }
        if(mHomeWaringStaticModel?.断电 != nil){
            mWaringMsgList.append("断电: \(mHomeWaringStaticModel?.断电 ?? "")")
        }
        if(mHomeWaringStaticModel?.超限 != nil){
            mWaringMsgList.append("超限: \(mHomeWaringStaticModel?.超限 ?? "")")
        }
        addWaringView(waringMsgList: mWaringMsgList)
    }
    
    //创建报警显示区域
    func addWaringView(waringMsgList : [String]){

         let waringTitleH = 30
         let waringTitleView = HomeTitleVIew()
        mWaringTitleView = waringTitleView
         waringTitleView.frame =  CGRect(x: 0, y: Int(mTypeBtnViews.bottom) + typeViewMarginCycleView  , width: Int(mScreenW) , height: waringTitleH)
         waringTitleView.titleLabel.text = "报警信息"
         mHeadView.addSubview(waringTitleView)
      
        
        if(mWaringView == nil) {
            mWaringView = UIView()
        }
        for view in mWaringView.subviews {
            view.removeFromSuperview()
        }
        
        mWaringView.backgroundColor = cellBgColor
        mWaringView.layer.cornerRadius = CGFloat(clickRadius)
        mWaringView.clipsToBounds = true
        let waringX = commonLeftMargin + 10
        let waringW = mScreenW - CGFloat(commonLeftMargin * 2) - ( CGFloat(waringX * 2))
        let waringH = 20
        var waringY = 10
        let topMargin = 10
        
        for (index,str) in waringMsgList.enumerated() {
            let label = UILabel()
            waringY = topMargin + (topMargin + waringH) * index
            label.text = str
            label.font = UIFont.systemFont(ofSize: 12)
            label.textColor = .white
            label.frame = CGRect(x: waringX, y: waringY, width: Int(waringW), height: waringH)
            label.textAlignment = .center
            label.isUserInteractionEnabled = true
            label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(gotoHomeWaringController)))
            mWaringView.addSubview(label)
            
            if index == waringMsgList.count - 1 {
                mWaringView.frame =  CGRect(x: commonLeftMargin , y:Int(waringTitleView.bottom), width: Int(mScreenW) - (commonLeftMargin * 2), height:  Int(waringY + waringH + 10))
            }
        }
        
        mHeadView.addSubview(mWaringView)
        let mHeadviewH =  jCycleViewH + jCycleTopMargin + (typeViewMarginCycleView * 2)
        
        mHeadView.frame = CGRect(x: 0, y: 0, width: Int(mScreenW), height :mHeadviewH + Int(mTypeBtnViews.frame.size.height) + Int(mWaringView.frame.size.height) + waringTitleH)
        
        tableView.addSubview(mHeadView)
    }
    
    //跳转进入首页报警概述界面
    @objc func gotoHomeWaringController(){
        self.navigationController?.pushViewController(HomeWaringListViewController(), animated: true)
    }
    
    //选择矿区
    @objc func chooseMine(sender:UIButton){
        if dismissView == nil {
            createPickView()
        }
    }
    
    //按下事件
    @objc func touchDown(sender: UIButton){
        typeViewsAction(flag: 0,tag:sender.tag)
    }
    
    //按下后移出抬起
    @objc func touchUpOutside(sender:UIButton){
        typeViewsAction(flag: 1,tag:sender.tag)
        
    }
    
    //点击进入详情
    @objc func touchUpInside(sender:UIButton){
        typeViewsAction(flag: 2,tag:sender.tag)
        if(sender.tag == 0 ){
            self.navigationController?.pushViewController(KJ70DataController(), animated: true)
        }
        else if sender.tag == 1 {
            self.navigationController?.pushViewController(KJ128DataController(), animated: true)
        }else if sender.tag == 3 {
            self.navigationController?.pushViewController(KuangyaController(), animated: true)
        }
        else{
            AlertHepler.showAlert(titleStr: "提示", msgStr: "功能暂待后期开发", currentVC: self, cancelHandler: { (canleAction) in
                return
            }, otherBtns: nil, otherHandler: nil)
        }
    }
    
    func typeViewsAction(flag:Int , tag:Int){
        for view in mTypeBtnViews.subviews {
            if view is TypeButtonView {
                let typeView = view as! TypeButtonView
                if flag == 0 { // 按下
                    if tag == typeView.typeClickBtn.tag {
                        typeView.contentView.backgroundColor = greenColor
                        typeView.typelogImg.image = UIImage(named: touchTypeImages[tag])
                    }
                }else if flag == 1{ //移出抬起
                    //处理背景颜色
                    if tag == typeView.typeClickBtn.tag {
                        typeView.contentView.backgroundColor = cellBgColor
                        typeView.typelogImg.image = UIImage(named: normalTypeImages[tag])
                    }
                }else{ // 内部抬起
                    //处理背景颜色
                    if tag == typeView.typeClickBtn.tag {
                        typeView.contentView.backgroundColor = cellBgColor
                        typeView.typelogImg.image = UIImage(named: normalTypeImages[tag])
                    }
                }
                
            }
        }
    }
}

extension HomeController:UIPickerViewDelegate,UIPickerViewDataSource {
    
    //创建pickview
    func createPickView()  {
        view.endEditing(true)
        let window = UIApplication.shared.windows[0]
        dismissView = UIView(frame: CGRect(x: 0, y: 0, width: mScreenW, height: mScreenH))
        dismissView.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.35)
        dismissView.isUserInteractionEnabled = true
        let dismisTap = UITapGestureRecognizer(target: self, action: #selector(dismissTap))
        dismisTap.numberOfTapsRequired = 1
        dismissView.addGestureRecognizer(dismisTap)
        window.addSubview(dismissView)
        
        let pickH :CGFloat = 300
        pickerBottomView =  UIView(frame: CGRect(x: 0, y: mScreenH - pickH, width: mScreenW, height:pickH))
        pickerBottomView.backgroundColor = mainColor
        window.addSubview(pickerBottomView)
        
        let actionView =  UIView(frame: CGRect(x: 0, y:0, width: mScreenW, height:30))
        //           actionView.layer.borderColor =  UIColor.gray.cgColor
        //           actionView.layer.borderWidth = 0.5
        pickerBottomView.addSubview(actionView)
        
        let button = UIButton(frame:CGRect(x: mScreenW-100, y: 0, width: 90, height: 30))
        button.setTitleColor(UIColor.white, for: .normal)
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
        
        dismissTap()
        //TODO: 这边添加要处理的代码
        let mine :MineModel =  mineArr[row]
        let titleStr =  mine.SimpleName
        navTitView.titleBtn?.setTitle(titleStr, for: .normal)
        UserDefaults.standard.set(mine.Minecode, forKey: "mineCode")
        UserDefaults.standard.set(mine.SimpleName,forKey: "mineName")
        
    }
    
    //设置PickerView列数(dataSourse协议)
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1  //返回多少行
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return mineArr.count
    }
    //设置PickerView行数(dataSourse协议)      //设置PickerView选项内容(delegate协议)
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return  mineArr[row].SimpleName
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
        showLabel.text =  mineArr[row].SimpleName
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

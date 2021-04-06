//
//  LineChartsVC.swift
//  ShineApp
//
//  Created by jiang.123 on 2020/4/15.
//  Copyright © 2020 jiang.123. All rights reserved.
//

import UIKit
import Charts
import MJRefresh
class LineChartsVC: BaseViewController {

 //没有数据界面
 private var noDataView : ListStateView = ListStateView()
    private lazy var myViewModel : HistoryRequestModel = HistoryRequestModel()
    private var mModelList : [SimulatesCurveInfoModel] = [SimulatesCurveInfoModel]()
    var beginDate : String!
       var endDate : String!
       var mSensor : String!
    private let navH = 64
    private var lineChartView :  LineChartView!
    private var xVals:[String] = []
    private var yValue:[NSNumber] = []


       fileprivate lazy var tableView : UITableView  = {
        let tableview = UITableView(frame: CGRect(x: 0, y: 64, width: Int(mScreenH), height: Int(mScreenW) - 64))
           tableview.tag = 1001
           tableview.separatorStyle = UITableViewCell.SeparatorStyle.none
           tableview.backgroundColor = mainColor
           return tableview
       }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "历史模拟量折线图"
        self.view.backgroundColor = mainColor
        modalPresentationStyle = UIModalPresentationStyle.fullScreen

              let headView : UIView  = UIView()
              headView.frame = CGRect(x: 0, y: 0, width: Int(mScreenH), height: Int(navH))
              headView.backgroundColor = cellBgColor


              let backButton = UIButton()

              backButton.frame = CGRect(x: 10, y: (navigationBarHeight - 40) * 0.5, width: 40, height: 40)

              backButton.setImage(UIImage(named: "back_arrow.png")?.withRenderingMode(.alwaysOriginal), for: .normal)
              backButton.addTarget(self, action: #selector(backClick), for: .touchUpInside)
              headView.addSubview(backButton)

              let titleLabel = UILabel()
                  titleLabel.frame = CGRect(x: (mScreenH - 140) * 0.5, y:  (navigationBarHeight - 30) * 0.5, width: 140, height: 30)
              titleLabel.font = UIFont.systemFont(ofSize: 16)
              titleLabel.textColor = UIColor.white
              titleLabel.text  = "历史模拟量折线图"
              headView.addSubview(titleLabel)
             self.view.addSubview(headView)
             self.view.addSubview(tableView)
        noDataView.frame = CGRect(x: 0, y: Int(navigationBarHeight), width: Int(mScreenH), height: Int(mScreenW)  - Int(navigationBarHeight))
        noDataView.isHidden = true
        self.view.addSubview(noDataView)

         setRefresh()
    }


    //添加refresh
       func setRefresh(){
           let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(loadData))
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


  @objc func loadData(){
        self.myViewModel.GetKj70HisSimulatesCurveInfo(sensorNum: mSensor, beginTime: beginDate, endTime: endDate) {
            if self.myViewModel.lineDataModels.count > 0 {
                self.noDataView.isHidden = true
                self.mModelList.removeAll()
                self.mModelList = self.myViewModel.lineDataModels

                for model in self.mModelList {
                    self.yValue.append(model.avgValue)
                    let xval : String = model.statisticTime!
                    let indexStart = xval.startIndex
                    let beginIndex = xval.index(indexStart, offsetBy: 11)
                    let endIndex = xval.index(indexStart, offsetBy: xval.count - 1)
                    let newxval = xval[beginIndex...endIndex]
                    self.xVals.append(String(newxval))
                }
                self.tableView.mj_header.endRefreshing()
                self.tableView.isHidden = true
                self.addLineChartView()
            }else{
                self.noDataView.isHidden = false
            }
        }
    }

    //添加折线图
    func addLineChartView() {
       lineChartView = LineChartView(frame: CGRect(x: 0, y:navigationBarHeight , width: mScreenH, height:mScreenW - navigationBarHeight ))
        lineChartView.backgroundColor = mainColor
       lineChartView.noDataText = "暂无统计数据" //无数据的时候显示
        lineChartView.tintColor = .white
       lineChartView.chartDescription?.enabled = true //是否显示描述
       lineChartView.scaleXEnabled = true
       lineChartView.scaleYEnabled = false
        lineChartView.zoom(scaleX: 3, scaleY: 1, x: 0, y: 0) //设置缩放倍数

        lineChartView.leftAxis.drawGridLinesEnabled = false //左侧y轴设置，不画线
        lineChartView.rightAxis.drawGridLinesEnabled = false //右侧y轴设置，不画线
        lineChartView.rightAxis.drawAxisLineEnabled = false
        lineChartView.rightAxis.enabled = false
        lineChartView.legend.enabled = true
        lineChartView.dragEnabled = true//启动拖拽图标
        lineChartView.legend.enabled = true; // 隐藏说明
        lineChartView.legend.textColor = UIColor.yellow;

        self.lineChartView.dragDecelerationEnabled = true; //拖拽后是否有惯性效果
        self.lineChartView.dragDecelerationFrictionCoef = 0.9;//拖拽后惯性效果的摩擦系数(0~1),数值越小,惯性越不明显

        //设置X轴样式
        let xAxis = self.lineChartView.xAxis;
        xAxis.enabled = true;
        xAxis.axisLineWidth = 1;//设置X轴线宽
        xAxis.labelPosition = .bottom//X轴的显示位置，默认是显示在上面的
        xAxis.drawGridLinesEnabled = false;//不绘制网格线
        xAxis.drawLabelsEnabled = true;
        xAxis.granularity = 1.0
//        xAxis.spaceBetweenLabels = 4;//设置label间隔
        xAxis.labelTextColor = UIColor.white//label文字颜色
        xAxis.axisLineColor = UIColor.white


        xAxis.valueFormatter = IndexAxisValueFormatter(values: xVals)


        //设置Y轴样式
        lineChartView.rightAxis.enabled = false//不绘制右边轴
        let leftAxis = self.lineChartView.leftAxis;//获取左边Y轴
        leftAxis.labelCount = 6//Y轴label数量，数值不一定，如果forceLabelsEnabled等于YES, 则强制绘制制定数量的label, 但是可能不平均
         leftAxis.drawGridLinesEnabled = false
         leftAxis.drawGridLinesEnabled = false
        //    leftAxis.drawAxisLineEnabled = false;
        leftAxis.forceLabelsEnabled = false//不强制绘制指定数量的label
            // leftAxis.showOnlyMinMaxEnabled = false;//是否只显示最大值和最小值
        leftAxis.axisMinimum = 0;//设置Y轴的最小值
        leftAxis.drawZeroLineEnabled = true//从0开始绘制
        //    leftAxis.axisMaximum = 105;//设置Y轴的最大值
        leftAxis.inverted = false//是否将Y轴进行上下翻转
        leftAxis.axisLineWidth = 1//Y轴线宽
        leftAxis.axisLineColor = UIColor.white//Y轴颜色
        leftAxis.labelPosition = .outsideChart
        leftAxis.labelTextColor = UIColor.white//文字颜色
        leftAxis.labelFont = UIFont.systemFont(ofSize: 10)

        self.view.addSubview(lineChartView)
        //设置数据
        var dataEntris = [ChartDataEntry]()
        for (index,val) in yValue.enumerated() {
            let dataEntry = ChartDataEntry(x:Double(index), y: Double(val))
            dataEntris.append(dataEntry)
        }
        let dataset = LineChartDataSet(values: dataEntris, label: "\(String(describing: beginDate)) 平均值")
        dataset.setColor(UIColor.yellow)//线颜色
        dataset.setCircleColor(UIColor.white) // 点颜色
        dataset.valueColors = [UIColor.white] // 字颜色

        dataset.highlightColor = UIColor.yellow
        dataset.lineWidth = 1.0
        dataset.circleRadius = 3.0
                //legend 的一些设置，标记大小，字体等，在初始化的时候进行了设置
        dataset.valueFont = .systemFont(ofSize: 10)
        dataset.formLineDashLengths = [5.0, 2.5]
        dataset.formLineWidth = 1.0
        dataset.formSize = 15.0
        dataset.drawFilledEnabled = false // 是否绘制填充北京
          dataset.fillColor = UIColor.white // 填充背景色
//        dataset.drawCirclesEnabled = false
        dataset.drawValuesEnabled = true


        lineChartView.data = LineChartData(dataSet: dataset)
        lineChartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0, easingOption: .easeInBack)
    }


     @objc func backClick(){
         self.navigationController?.popViewController(animated: true)
     }
}

extension LineChartsVC {
    //运行页面随设备转动
      override open var shouldAutorotate: Bool {
          return true
      }
        override func viewWillAppear(_ animated: Bool) {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                //允许横屏
                appDelegate.isLandscape = true

                //强制为横屏 ， 如果是不强制横屏注视下面两行代码即可
                let value = UIInterfaceOrientation.landscapeLeft.rawValue
                UIDevice.current.setValue(value, forKey: "orientation")

            }
            super.viewWillAppear(animated)
        }

        override func viewWillDisappear(_ animated: Bool) {
            navigationController?.setNavigationBarHidden(false, animated: false)

            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                //禁止横屏
                appDelegate.isLandscape = false
            }
            //强制为竖屏
            let value = UIInterfaceOrientation.portrait.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
            super.viewWillDisappear(animated)
        }

        override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
            coordinator.animate(alongsideTransition: { [weak self] (context) in
                let orient = UIApplication.shared.statusBarOrientation
                switch orient {
                case .landscapeLeft, .landscapeRight:
                    //横屏时禁止左拽滑出
                    self?.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
                    self?.navigationController?.setNavigationBarHidden(true, animated: false)
                default:
                    //竖屏时允许左拽滑出
                    self?.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
                    self?.navigationController?.setNavigationBarHidden(false, animated: false)
                }
            })
            super.viewWillTransition(to: size, with: coordinator)
        }


      //支持的方向： 右边
      override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
          return .landscapeLeft
      }
      // 优先展示的方向： 右边
      override open var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
          return .landscapeLeft
      }
}

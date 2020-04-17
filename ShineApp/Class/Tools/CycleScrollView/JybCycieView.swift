//
//  RecommendCycieView.swift
//  DYZB
//
//  Created by jiang.123 on 2019/6/19.
//  Copyright © 2019年 jiang.123. All rights reserved.
// 轮播view jyb

import UIKit

private let kCycleCellID = "kCycleCellID"

class JybCycieView: UIView {
    //MARK: 定义展示属性d
    //定时器
    var cycleTimer : Timer?
    var cycleModels : [[String : AnyObject]]?{
        didSet{
            //刷新collectionview
            collectionView.reloadData()
            
            //设置pagecontroller个数
            
            pageController.numberOfPages = cycleModels?.count ?? 0
            
           
            
            if(cycleModels!.count > 1){
                //为了实现往前滚 默认将collectionView 滚到一个位置
                let indexPath = IndexPath(item: (cycleModels?.count ?? 0)*20, section: 0)
                collectionView.scrollToItem(at: indexPath , at: .left, animated: false)
                // 4.添加定时器
            }
            removeCycleTimer()
            addCycleTimer()
            
        }
    }
    //控件属性
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageController: UIPageControl!
    
    //系统回调函数
    override func awakeFromNib() {
        super.awakeFromNib()
        //设置该空间不随父控件的拉伸而拉伸
        autoresizingMask = UIView.AutoresizingMask()
        
//        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kCycleCellID)

        //注册cell
        collectionView.register(UINib(nibName: "CollectionCycleCell", bundle: nil), forCellWithReuseIdentifier: kCycleCellID)
        collectionView.showsHorizontalScrollIndicator = false;
        collectionView.isPagingEnabled = true
        collectionView.dataSource = self
        collectionView.delegate = self;
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // 设置collectionView的layout  设置layout 需要f在layoutSubviews 进行,不然cell 会有偏移
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = collectionView.bounds.size
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
    }

}

//MARK :- 提供一个快速创建view 的类方法
extension JybCycieView {
    class func createCycieView() -> JybCycieView {
        return  Bundle.main.loadNibNamed("JybCycieView", owner: nil, options: nil)?.first as! JybCycieView
    }
}

//MARK: 遵守collectionView的数据源协议

extension JybCycieView : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (cycleModels?.count ?? 0)*10000
        //return cycleModels?.count ?? 0
    }
    
 func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
//        let cycleModel = cycleModels![indexPath.item % cycleModels!.count]
      let cycleDic = cycleModels![indexPath.item % cycleModels!.count]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCycleCellID, for: indexPath) as! CollectionCycleCell
        
        //cell.cycleModel = cycleModel
        cell.cycleDic = cycleDic
        return cell
    }
}
// MARK:- 遵守UICollectionView的代理协议
extension JybCycieView : UICollectionViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 1.获取滚动的偏移量
        let offX = scrollView.contentOffset.x + scrollView.bounds.width*0.5
        
        pageController.currentPage = Int(offX / scrollView.bounds.width) % (cycleModels?.count ?? 1)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        removeCycleTimer()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        addCycleTimer()
    }
}

//MARK:- 对定时器的操作方法

extension JybCycieView{
    
    fileprivate func addCycleTimer(){
        cycleTimer = Timer(timeInterval: 3.0, target: self, selector: #selector(scrollToNext), userInfo: nil, repeats: true)
        RunLoop.main.add(cycleTimer!, forMode: RunLoop.Mode.common)
    }
    
    fileprivate func removeCycleTimer() {
        cycleTimer?.invalidate()// 从运行循环中移除
        cycleTimer = nil
    }
    
    @objc fileprivate func scrollToNext () {
        // 1.获取滚动的偏移量
        let currentOffsetX = collectionView.contentOffset.x
        let offsetX = currentOffsetX + collectionView.bounds.width
        // 2.滚动该位置
        collectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
    }
}

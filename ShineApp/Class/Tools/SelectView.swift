//
//  SelectView.swift
//  ShineApp
//
//  Created by jiang.123 on 2020/3/31.
//  Copyright © 2020 jiang.123. All rights reserved.
//


import UIKit


class SelectView: UIView {
    
    var selecctData: [String]?
    var action: ((_ index: Int) -> ())?
    var imagesData: [String]?
    
    static var backgroundView: SelectView?
    static var tableView:UITableView?
    

    
    class func addPellView(frame:CGRect, selectData: Array<Any>, images: Array<String>, animate:Bool, action:@escaping ((_ index: Int)->())) {
        
        if backgroundView != nil {
            hidden()
        }
        
        let win:UIWindow = UIApplication.shared.windows[0]
        backgroundView = SelectView(frame: win.bounds)
        backgroundView?.action = action
        backgroundView?.imagesData = images
        backgroundView?.selecctData = selectData as? [String]
        backgroundView?.backgroundColor = UIColor(hue: 0, saturation: 0, brightness: 0, alpha: 0.4)
        
        win.addSubview(backgroundView!)
        
        tableView = UITableView(frame: CGRect(x: UIScreen.main.bounds.width - frame.size.width + (frame.size.width/2.0), y: 64.0 - (40.0 * CGFloat(selectData.count)/2.0), width: frame.size.width, height: 40.0 * CGFloat(selectData.count)), style: .plain)
        
        tableView?.dataSource = backgroundView
        tableView?.delegate = backgroundView
        tableView?.layer.cornerRadius = 6
        // 锚点
        tableView?.layer.anchorPoint = CGPoint(x: 1.0, y: 0)
        tableView?.transform = CGAffineTransform(scaleX: 0.00001, y: 0.00001)
        tableView?.rowHeight = 40
        win.addSubview(tableView!)
        
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapbackgroundClick))
        backgroundView?.addGestureRecognizer(tap)
        backgroundView?.action = action
        backgroundView?.selecctData = (selectData as! [String])
        
        if animate {
            backgroundView?.alpha = 0
            UIView.animate(withDuration: 0.3) {
                backgroundView?.alpha = 0.5
                tableView?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }
        }
    }

    class func hidden() {
        if backgroundView != nil {
            UIView.animate(withDuration: 0.3, animations: {
                tableView?.transform = CGAffineTransform(scaleX: 0.00001, y: 0.00001)
            }) { (finished) in
                backgroundView?.removeFromSuperview()
                tableView?.removeFromSuperview()
                tableView = nil
                backgroundView = nil
            }
        }
    }
    
    @objc class func tapbackgroundClick() {
        hidden()
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

let SelectViewIdentifier = "SelectViewIdentifier"
extension SelectView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (selecctData?.count)!
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: SelectViewIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: SelectViewIdentifier)
        }
        if (imagesData?.count)! > 0 {
            cell?.imageView?.image = UIImage(named: imagesData![indexPath.row])
        }
        
        cell?.textLabel?.text = selecctData?[indexPath.row]
        cell?.textLabel?.textAlignment = NSTextAlignment.center
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 15)
        cell?.textLabel?.textColor = UIColor(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 1.0)
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if (self.action != nil) {
            self.action!(indexPath.row)
        }
        SelectView.hidden()
    }
}

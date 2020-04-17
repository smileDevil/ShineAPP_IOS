//
//  MineModel.swift
//  ShineApp
//
//  Created by jiang.123 on 2020/3/30.
//  Copyright © 2020 jiang.123. All rights reserved.
//

import UIKit

@objcMembers
 class MineModel: NSObject {
    var TmpID : NSInteger = 0
    var Minecode : String = ""
    var SimpleName : String = ""
    var City : String = ""
    var FullName : String = ""
    var `Type` : String = ""
    var Managers : String = ""
    var Address : String = ""
    var Phone : String = ""
    var MiningBureau : String = ""
    var MACode : String = ""
    var MineGroup : String = ""
    var Coordinates : String = ""
    var Remark : String = ""
    var x : NSNumber!
    var y : NSNumber!
    init(dict : [String:Any]) {
          super.init()
          setValuesForKeys(dict)
      }
      
    override public func setValue(_ value: Any?, forUndefinedKey key: String) {}
}

@objcMembers
 class MineListModel: NSObject {
    var total : String = ""
    var rows : [[String:NSObject]]?{
        didSet {
                  guard let rows = rows else { return }
                  for dict in rows {
                      mineModelList.append(MineModel(dict: dict))
                  }
              }
    }
    
    lazy var mineModelList : [MineModel] = [MineModel]()
}

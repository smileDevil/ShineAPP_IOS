//
//  SimulatesCurveInfoModel.swift
//  ShineApp
//
//  Created by jiang.123 on 2020/4/16.
//  Copyright © 2020 jiang.123. All rights reserved.
//

import UIKit

class SimulatesCurveInfoModel: NSObject {
    var maxValue : NSNumber!
     var avgValue : NSNumber!
     var minValue : NSNumber!
     var statisticTime : String!
    var Place : String!
    var sensorNum : String!
    
    init(dict : [String:Any]) {
          super.init()
           setValuesForKeys(dict)
       }
       
       override func setValue(_ value: Any?, forUndefinedKey key: String) {
           
       }
}

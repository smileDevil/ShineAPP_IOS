//
//  DispatchQueue-Extension.swift
//  ShineApp
//
//  Created by jiang.123 on 2020/3/20.
//  Copyright © 2020 jiang.123. All rights reserved.
//

import Foundation
public extension DispatchQueue {
    private static var _onceTracker = [String]()
    
    class func once(file: String = #file, function: String = #function, line: Int = #line, block:()->Void) {
        let token = file + ":" + function + ":" + String(line)
        once(token: token, block: block)
    }
    
    /**
     Executes a block of code, associated with a unique token, only once.  The code is thread safe and will
     only execute the code once even in the presence of multithreaded calls.
     
     - parameter token: A unique reverse DNS style name such as com.vectorform.<name> or a GUID
     - parameter block: Block to execute once
     */
    class func once(token: String, block:()->Void) {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        
        
        if _onceTracker.contains(token) {
            return
        }
        
        _onceTracker.append(token)
        block()
    }
}

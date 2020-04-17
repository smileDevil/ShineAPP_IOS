//
//  View-Extension.swift
//  ShineApp
//
//  Created by jiang.123 on 2020/3/21.
//  Copyright © 2020 jiang.123. All rights reserved.
//

import UIKit
extension UIView {
    
    public func getLeft()  -> CGFloat{
        return self.frame.origin.x
    }
    
    public func getRight() -> CGFloat{
        return self.frame.size.width
       }
    
    
    public var left : CGFloat {
        get {
            return self.frame.origin.x
        }
        set(newVal) {
            var jyb_frame: CGRect = self.frame
            jyb_frame.origin.x = newVal
            self.frame = jyb_frame
        }
    }
    
    
    public var top: CGFloat {
        
        get {
            return self.frame.origin.y
        }
        
        set(newVal) {
            var jyb_frame: CGRect = self.frame
            jyb_frame.origin.y = newVal
            self.frame = jyb_frame
            
        }
        
    }
    
    
       public var right: CGFloat {
           get {
               return self.frame.size.width
           }
           
           set(newVal) {
               var jyb_frame: CGRect = self.frame
               jyb_frame.size.width = newVal
               self.frame = jyb_frame
               
           }
           
       }
    
    public var bottom: CGFloat {
        
        get {
            return self.frame.size.height
        }
        
        set(newVal) {
            var jyb_frame: CGRect = self.frame
            jyb_frame.size.height = newVal
            self.frame = jyb_frame
            
        }
    }
    
    public var jyb_size: CGSize {
          
          get {
              return self.frame.size
          }
          
          set(newVal) {
              var jyb_frame: CGRect = self.frame
              jyb_frame.size = newVal
              self.frame = jyb_frame
              
          }
          
      }
      
      public var jyb_centerX: CGFloat {
          
          get {
              return self.center.x
          }
          
          set(newVal) {
              var jyb_center: CGPoint = self.center
              jyb_center.x = newVal
              self.center = jyb_center
              
          }
          
      }
      
      public var jyb_centerY: CGFloat {
          
          get {
              return self.center.y
          }
          
          set(newVal) {
              var jyb_center: CGPoint = self.center
              jyb_center.y = newVal
              self.center = jyb_center
              
          }
          
      }
}


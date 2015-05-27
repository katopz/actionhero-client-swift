//
//  AHEmitter.swift
//  actionhero-client-swift
//
//  Created by katopz on 5/25/2558 BE.
//  Copyright (c) 2558 Debokeh. All rights reserved.
//

import Foundation
class AHEmitter {
    
    func on(name:String, _ handler:([NSObject : AnyObject]!) -> Void) {
        NSNotificationCenter.defaultCenter().addObserverForName(name, object: self, queue: nil, usingBlock: {
            notification in
            handler(notification.userInfo)
        })
    }
    
    func emit(name:String, _ data: NSDictionary? = nil) {
        let userInfo = data as [NSObject : AnyObject]?
        NSNotificationCenter.defaultCenter().postNotificationName(name, object: self, userInfo: userInfo)
    }
}
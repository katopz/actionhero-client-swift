//
//  DBKBlock.swift
//  primus-obj-swift-helloworld
//
//  Created by katopz on 5/19/2558 BE.
//  Copyright (c) 2558 Debokeh. All rights reserved.
//

import Foundation

class Block<T>  {
    let f : T
    init (_ f: T){ self.f = f }
    var casted: AnyObject { get { return unsafeBitCast(f, AnyObject.self) } }
}
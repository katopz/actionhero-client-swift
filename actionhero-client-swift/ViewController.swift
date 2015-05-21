//
//  ViewController.swift
//  actionhero-client-swift
//
//  Created by katopz on 5/20/2558 BE.
//  Copyright (c) 2558 Debokeh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var client:AHClient!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        client = AHClient()
        client.connect({
            self.client.roomAdd("defaultRoom");
        })
    }
}


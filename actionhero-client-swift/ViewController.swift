//
//  ViewController.swift
//  actionhero-client-swift
//
//  Created by katopz on 5/20/2558 BE.
//  Copyright (c) 2558 Debokeh. All rights reserved.
//

import UIKit
class AHData {}
class ViewController: UIViewController {

    var client:AHClient!
    var listener: Listener!
    @IBOutlet weak var chatTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        client = AHClient()

        listener = client.on { data in
            //println("data: \(data)")
            self.appendMessage("\(data)")
        }
        
        client.connect() {
            self.client.roomAdd();
        }
    }
    
    func appendMessage(message:String) {
        if !message.isEmpty {
            chatTextView.text = chatTextView.text + message + "\n"
        }
    }
}


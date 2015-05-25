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
    
    // h
    func toStringFromDate(date:NSDate) -> String {
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.LongStyle
        formatter.timeStyle = .MediumStyle
        
        return formatter.stringFromDate(date)
    }

    // m
    var client:AHClient!

    // v
    @IBOutlet weak var chatTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        client = AHClient()
        
        client.on("welcome"){ data in
            self.appendMessage(data)
        }
        
        client.on("say"){ data in
            self.appendMessage(data)
        }
        
        client.connect() {
            self.client.roomAdd();
        }
    }
    
    func appendMessage(message:[NSObject : AnyObject]) {
        if message.isEmpty {
            return
        }
    
        var s = ""
        if let msg = message["welcome"] as? String {
            s = msg
        } else {
            let timeStamp = (message["sentAt"] as! Double)/1000
            let date = NSDate(timeIntervalSince1970:timeStamp)
            s = toStringFromDate(date) + "[" + (message["from"] as! String) + "] " + (message["message"] as! String)
        }
        
        self.chatTextView.text = chatTextView.text + s + "\n"
    }
}


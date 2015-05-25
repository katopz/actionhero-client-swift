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
    @IBOutlet weak var msgTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        client = AHClient()
        
        client.on("alert") { message in println(message)}
        client.on("api") { message in println(message)}
        
        client.on("welcome") { message in self.appendMessage(message)}
        client.on("say") { message in self.appendMessage(message)}
        
        client.connect() {
            self.client.roomAdd();
        }
    }
    
    //MARK:- In
    
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
    
    //MARK:- Out
    
    typealias foo = (NSDictionary?) -> Void
    
    @IBAction func sayClicked(sender: AnyObject) {
        sendMessage()
    }
    
    func sendMessage() {
        let message:String = msgTextField.text
        
        if message.isEmpty {
            return
        }
        
        client.say(client.rooms[0], message: message) { data in
            println("Said!")
        }
    }
}


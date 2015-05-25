//
//  AHClient.swift
//  actionhero-client-swift
//
//  Created by katopz on 5/20/2558 BE.
//  Copyright (c) 2558 Debokeh. All rights reserved.
//

import Foundation

class AHClient:AHEmitter {
    
    typealias foo = NSDictionary -> Void
    
    var messageCount:Int = 0
    var client:Primus?
    var options:[String: NSObject]?
    var callbacks:[Int:foo]?
    var id:String?
    var fingerprint:String?
    //var events = {}
    var rooms:[String] = []
    var state:String = "disconnected"
    var welcomeMessage:String = ""
    
    // Primus
    var _PrimusConnectOptions:PrimusConnectOptions?
    
    func defaults() -> [String: NSObject] {
        return [
            "host": "127.0.0.1",
            "port": "5000",
            "delimiter": "\r\n",
            "logLength": 100,
            "secure": false,
            "timeout": 5000,
            "reconnectTimeout": 1000,
            "reconnectAttempts": 10
        ];
    }
    
    //MARK:- init
    
    override convenience init() {
        self.init(options: ["":""])
    }
    
    init(options:[String: NSObject]) {
        
        self.callbacks = [Int:foo]()
        //self.id = nil;
        //self.events = {};
        //self.rooms = [];
        //self.state = "disconnected";
        
        super.init()
        
        self.options = self.defaults();
        
        //self.init(options: [String: NSObject]())
        
        for (key, value) in options {
            self.options![key] = options[key];
        }
        
        _PrimusConnectOptions = PrimusConnectOptions()
        _PrimusConnectOptions!.transformerClass = SocketRocketClient.classForCoder()
        _PrimusConnectOptions!.timeout = 200
        //_PrimusConnectOptions.manual = true
    }
    
    //MARK:- CONNECTION
    
    func connect(callback:() -> Void) {
        
        self.messageCount = 0
        
        if(self.client == nil) {
            
            self.client = Primus(URL: NSURL(string: "http://127.0.0.1:8080/primus"), options:_PrimusConnectOptions)
        }  else {
            self.client?.end();
            self.client?.open();
        }
        
        self.client!.on("open", listener : Block<@objc_block () -> ()> {
            NSLog("[open] - The connection has been established.")
            
            if(self.state == "connected"){
                //
            }else{
                self.state = "connected";
                callback()
            }
            
        }.casted)
        
        self.client!.on("data", listener : Block<@objc_block (NSDictionary, AnyObject) -> ()> { (data: NSDictionary, raw: AnyObject) in
            self.handleMessage(data)
        }.casted)
    }
    
    func handleMessage(message: NSDictionary) {
        NSLog("[data] - Received data: %@", message);
        
        //self.emit(["message": message])
        
        let context: String = message["context"] as! String
        
        if context == "response" {

            let messageCount: Int = message["messageCount"] as! Int
            let _callback = self.callbacks?[messageCount] as foo!
            if (_callback != nil) {
                _callback(message)
            }

        } else if context == "user" {
            self.emit("say", message)
        } else if context == "alert" {
            self.emit("alert", message)
        } else if (message["welcome"] != nil) && context == "api" {
            self.welcomeMessage = message["welcome"] as! String
            self.emit("welcome", message)
        }else if context == "api" {
            self.emit("api", message)
        }
    }
    
    var details:String {
        get {
            return "TODO" // { apiPath: '/api', url: window.location.origin }
        }
    }
    
    func configure(details:NSDictionary, _ callback:foo?) {
        for room in rooms {
            self.send(["event": "roomAdd", "room": room])
        }
        
        self.detailsView(){ details in
            let data = details["data"] as! NSDictionary
            self.id          = data["id"] as? String
            self.fingerprint = data["fingerprint"] as? String
            self.rooms       = data["rooms"] as! [String]
            
            if let _callback = callback as foo! {
                _callback(details);
            }
        }
    }
    
    //MARK:- MESSAGING
    
    func send(args: [String: NSObject]) {
        self.send(args, callback:{ data in })
    }
    
    func send(args: [String: NSObject], callback:foo?) {
        
        self.messageCount++
        
        if let _callback = callback as foo! {
            self.callbacks?[self.messageCount] = _callback
        }
        
        self.client!.write(args)
    }
    
    //MARK:- COMMAND
    
    func detailsView(callback:foo?) {
        self.send(["event": "detailsView"], callback: callback)
    }
    
    func say(room:String, message:String, callback:foo?) {
        self.send(["event": "say", "room": room, "message": message], callback: callback)
    }
    
    func roomAdd() {
        roomAdd("defaultRoom", nil)
    }
    
    func roomAdd(room:String, _ callback:foo?) {
        self.send(["event": "roomAdd", "room": room], callback: { details in
            self.configure(details, callback)
        })
    }
}

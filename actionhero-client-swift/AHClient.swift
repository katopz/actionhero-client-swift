//
//  AHClient.swift
//  actionhero-client-swift
//
//  Created by katopz on 5/20/2558 BE.
//  Copyright (c) 2558 Debokeh. All rights reserved.
//

import Foundation

class AHClient {
    
    var messageCount:Int = 0
    var client:Primus?
    var options:Dictionary<String, NSObject>?
    //var callbacks
    var id:String?
    //var events = {}
    var rooms:[String]
    var state:String
    
    // Primus
    var _PrimusConnectOptions:PrimusConnectOptions?
    
    func defaults() -> Dictionary<String, NSObject> {
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
    
    convenience init() {
        self.init(options: Dictionary<String, NSObject>())
    }
    
    init(options:Dictionary<String, NSObject>) {
        //self.callbacks = {};
        //self.id = nil;
        //self.events = {};
        self.rooms = [];
        self.state = "disconnected";
        
        self.options = self.defaults();
        for (key, value) in options {
            self.options![key] = options[key];
        }
        
        _PrimusConnectOptions = PrimusConnectOptions()
        _PrimusConnectOptions!.transformerClass = SocketRocketClient.classForCoder()
        _PrimusConnectOptions!.timeout = 200
        //_PrimusConnectOptions.manual = true
    }
    
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
    
    func handleMessage(data: NSDictionary) {
        NSLog("[data] - Received data: %@", data);
        
        let context: String = data["context"] as! String
        
        if context == "api" {
            if (data["welcome"] != nil) {
                // {"event":"detailsView"}
                self.client!.write(["event": "detailsView"]);
            }
        }else if context == "response" {
            
            let messageCount: Int = data["messageCount"] as! Int
            
            if messageCount == 1 {
                // {"event":"roomAdd","room":"defaultRoom"}
                self.client!.write(["event": "roomAdd", "room": "defaultRoom"]);
            } else if messageCount == 2 {
                // {"event":"say","room":"defaultRoom","message":"HelloWorld!"}
                self.client!.write(["event": "say", "room": "defaultRoom", "message": "HelloWorld from Swift!"]);
            }
        }
    }
    
    var details:String {
        get {
            return "TODO"
        }
    }
}
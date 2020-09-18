//
//  ViewController.swift
//  ASPingTest
//
//  Created by PC Gamer on 18/09/20.
//  Copyright © 2020 Avadhesh. All rights reserved.
//

import UIKit

class ViewController: UIViewController, SimplePingDelegate {
    
    //MARK:
    var pinger: SimplePing? = nil
    var timer: DispatchSourceTimer? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // initial setup
        getRouterInfo()
    }
    
    fileprivate func getRouterInfo() {
        let router = LDSRouterInfo.getRouterInfo()
        pinger = SimplePing(hostName: router["ip"] as! String)
        pinger?.delegate = self
        pinger?.start()
    }
    
    
    //MARK: SimplePing Delegates
    func simplePing(_ pinger: SimplePing, didStartWithAddress address: Data) {
        if (timer != nil) {
            return
        }
        timer = DispatchSource.makeTimerSource(queue: DispatchQueue.main)
        timer?.schedule(deadline: .now(), repeating: .seconds(1), leeway: .seconds(1))
        timer?.setEventHandler(handler: {
            pinger.send(with: nil)
        })
        timer?.resume()
    }
    
    func simplePing(_ pinger: SimplePing, didSendPacket packet: Data, sequenceNumber: UInt16) {
        print("PING: success!!!")
    }
    
    func simplePing(_ pinger: SimplePing, didReceivePingResponsePacket packet: Data, sequenceNumber: UInt16) {
        print("PING: received \(packet)")
    }
    
    func simplePing(_ pinger: SimplePing, didFailToSendPacket packet: Data, sequenceNumber: UInt16, error: Error) {
        let err = error as NSError
        if err.code == 65 {
            print("PING: transmission failed!!!")
        }
    }
}

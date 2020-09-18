//
//  ViewController.swift
//  ASPingTest
//
//  Created by PC Gamer on 18/09/20.
//  Copyright © 2020 Avadhesh. All rights reserved.
//

import UIKit
import TinyConsole

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
        
        if let routerIP = router["ip"] as? String {
            pinger = SimplePing(hostName: routerIP)
            pinger?.delegate = self
            pinger?.start()
            
            consolePrint(routerIP)
        }
    }
    
    //MARK: SimplePing Delegates
    func simplePing(_ pinger: SimplePing, didStartWithAddress address: Data) {
        if (timer != nil) {
            return
        }
        timer = DispatchSource.makeTimerSource(queue: DispatchQueue.main)
        timer?.schedule(deadline: .now(), repeating: .seconds(2), leeway: .seconds(1))
        timer?.setEventHandler(handler: {
            pinger.send(with: nil)
        })
        timer?.resume()
    }
    
    func simplePing(_ pinger: SimplePing, didSendPacket packet: Data, sequenceNumber: UInt16) {
        consolePrint("PING: didSendPacket \(packet)")
    }
    
    func simplePing(_ pinger: SimplePing, didReceivePingResponsePacket packet: Data, sequenceNumber: UInt16) {
        consolePrint("PING: didReceivePingResponsePacket \(packet)")
    }
    
    func simplePing(_ pinger: SimplePing, didFailToSendPacket packet: Data, sequenceNumber: UInt16, error: Error) {
        let err = error as NSError
        if err.code == 65 {
            consolePrint("PING: didFailToSendPacket \(err.description)",error: error)
        }
    }
}

extension ViewController {
    
    func consolePrint(_ content: String, error: Error? = nil) {
        TinyConsole.print(content)
        if let _ = error {
            TinyConsole.addLine()
        }
    }
}

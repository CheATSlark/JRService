//
//  NetTime.swift
//  23
//
//  Created by 焦瑞洁 on 2020/11/2.
//  Copyright © 2020 ddcx. All rights reserved.
//

import Foundation

class NetworkServiceTime {
    
    private let pid = ProcessInfo().processIdentifier
    private var currentTime = timeval(tv_sec: 0, tv_usec: 0)
    private var bootTime = timeval()
    private var size = MemoryLayout<kinfo_proc>.stride
    private var mib: [Int32]
    private var kp = kinfo_proc()
    
    init() {
        mib = [CTL_KERN, KERN_PROC, KERN_PROC_PID, pid]
    }
    
    private func processLaunchTime() -> Double {
        sysctl(&mib, u_int(mib.count), &kp, &size, nil, 0)
        gettimeofday(&currentTime, nil)
        
        let bootTime = kp.kp_proc.p_un.__p_starttime
        return toSeconds(time: currentTime) - toSeconds(time: bootTime)
    }
    
    private func toSeconds(time: timeval) -> Double {
        let microsecondsInSecond = 1000000.0
        return Double(time.tv_sec) + Double(time.tv_usec) / microsecondsInSecond
    }
    
    func persistenceInfo(netTime: Int){
        let locationRefrence = Int(processLaunchTime()*1000)
        let timeInfo = ["refrence": String(locationRefrence), "net": String(netTime)]
//        UDConfiguration.netTime = timeInfo
    }
    
    func readNetTime() -> Int? {
//        let timeInfo = UDConfiguration.netTime
//        if let reference = timeInfo?["refrence"] as? String, let netTime = timeInfo?["net"] as? String, let referInt = Int(reference), let netInt = Int(netTime) {
//            return Int(processLaunchTime()*1000) - referInt + netInt
//        }else{
            return nil
//        }
    }
}

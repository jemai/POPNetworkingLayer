//
//  Reachability.swift
//  endiosOne-iOS
//
//  Created by Abdelhak Jemaii on 17.10.18.
//  Copyright © 2018 Abdelhak Jemaii. All rights reserved.
//

import Foundation
import SystemConfiguration

/*
 *          // MARK: - <#Reachability protocol#>
 *   this protocol is the one responsible for connectivity checking
 *   it contains 2 ways of checking:
 *   - isReachable   : this is a boolean var that will check if the device is connected to internet
 *   - isUrlReachable: this func takes as parameter a URL anch check if that url is reachable abd returns a Bool
 */

public protocol ReachabilityProtocol {
    static var isReachable: Bool {get}
    static func isUrlReachable(url: URL) -> Bool
}

extension ReachabilityProtocol {
    public static var isReachable: Bool {
        get {
            var zeroAddress = sockaddr()
            zeroAddress.sa_len = UInt8(MemoryLayout<sockaddr>.size)
            zeroAddress.sa_family = sa_family_t(AF_INET)
            
            guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
                SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
            }) else { return false }
            
            var flags = SCNetworkReachabilityFlags()
            guard SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) else { return false }
            
            return flags.contains(.reachable) && !flags.contains(.connectionRequired)
        }
    }
    //
    public static func isUrlReachable(url: URL) -> Bool {
        let reachability = SCNetworkReachabilityCreateWithName(nil, url.absoluteString)
        var flags = SCNetworkReachabilityFlags()
        SCNetworkReachabilityGetFlags(reachability!, &flags)
        return flags.contains(.reachable)
    }
}



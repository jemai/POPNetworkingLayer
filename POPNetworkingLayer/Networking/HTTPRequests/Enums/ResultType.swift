//
//  ResultType.swift
//  Networking
//
//  Created by Abdelhak Jemaii on 25/05/2018.
//  Copyright © 2018 Abdelhak Jemaii. All rights reserved.
//

import Foundation

public enum HTTPResult<U,V> {
    case success(U)
    case failure(V)
}

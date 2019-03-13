//
//  HTTPCallErrorType.swift
//  Networking
//
//  Created by Abdelhak Jemaii on 25/05/2018.
//  Copyright © 2018 Abdelhak Jemaii. All rights reserved.
//

import Foundation

public enum HTTPCallErrorType<E> {
    case urlError
    case dataError
    case responseError(E)
    case mappingError(E)
}

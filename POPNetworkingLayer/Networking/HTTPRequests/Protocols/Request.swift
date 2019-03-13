//
//  Request.swift
//  Networking
//
//  Created by Abdelhak Jemaii on 25/05/2018.
//  Copyright © 2018 Abdelhak Jemaii. All rights reserved.
//

import Foundation

public typealias Headers    = [String: String]
public typealias Params     = [String: String]
public typealias BodyParams = [String: Any]

public protocol Request {
    var urlString   : String?           { get }
    var method      : HTTPMethod        { get }
    var bodyParams  : BodyParams?       { get }
    var headers     : Headers?          { get }
    var params      : Params?           { get }
}

public extension Request {
    public var method      : HTTPMethod        { return .get }
    public var bodyParams  : BodyParams?       { return nil }
    public var headers     : Headers?          { return nil }
}

public struct HTTPRequest: Request {
    public var params:     Params?
    public var bodyData:   Data?
    public var urlString:  String?
    public var method:     HTTPMethod = .get
    public var bodyParams: BodyParams? = nil
    public var headers:    Headers? = ["Content-Type" : "application/json"]

    public init(url: String) {
        self.urlString = url
    }
    
    public init(url: String, headers: Headers?, bodyParams: BodyParams?, method: HTTPMethod, params: Params? = nil) {
        self.urlString = url
        self.method = method
        self.headers = headers
        self.bodyParams = bodyParams
        self.params = params
    }
}

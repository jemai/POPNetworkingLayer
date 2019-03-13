//
//  Requester.swift
//  Networking
//
//  Created by Abdelhak Jemaii on 25/05/2018.
//  Copyright © 2018 Abdelhak Jemaii. All rights reserved.
//

import Foundation
//import RealmSwift

public protocol Requester {
    static var queue: OperationQueue {get}
    static func execute<T: Codable>(ofType: T.Type, request : Request,
                        completion: @escaping
        (_ result: HTTPResult<T?,HTTPCallErrorType<Error>?>) -> Void)
}

extension Requester {
    
    public static func execute<T: Codable>(ofType: T.Type, request : Request,
                                           completion: @escaping
        (_ result: HTTPResult<T?,HTTPCallErrorType<Error>?>) -> Void) {

        if let httpRequest = createRequest(from: request) {

            URLSession.shared.dataTask(with: httpRequest) { (data, response, error) in
                if let error = error {
                    completion(HTTPResult.failure(HTTPCallErrorType.responseError(error)))
                } else {
                    DispatchQueue.main.async {
                        if let data = data {
                            do {
                                let object = try JSONDecoder().decode(T.self, from: data)
                                completion(HTTPResult.success(object))
                                return
                            } catch let error {
                                completion(HTTPResult.failure(HTTPCallErrorType.mappingError(error)))
                                return
                            }
                        }
                        completion(HTTPResult.failure(HTTPCallErrorType.dataError))
                    }
                }
                }.resume()
        } else {
            completion(HTTPResult.failure(HTTPCallErrorType.urlError))
        }
    }
    
    // MARK: - Helper func
    private static func createRequest(from request: Request) -> URLRequest? {
        //
        var urlComponents: URLComponents
        if let components = URLComponents(string: request.urlString ?? "default value") {
            urlComponents = components
        } else {
            return nil
        }
        
        if let params = request.params {
            urlComponents.set(parameters: params)
        }
        
        guard let url = urlComponents.url else {
            fatalError()
        }
        
        var httpRequest = URLRequest(url: url)
        httpRequest.httpMethod = request.method.rawValue.uppercased()
        httpRequest.cachePolicy = .useProtocolCachePolicy
        httpRequest.timeoutInterval = 10.0
        httpRequest.httpBody = request.bodyParams?.data
        //
        if let headers = request.headers {
            httpRequest.allHTTPHeaderFields = headers
        }
        return httpRequest
    }
}


// MARK: - Extensions
public extension Dictionary {
    var data: Data? {
        return try? NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: true)
    }
}

extension URLComponents {
    mutating func set(parameters: [String: String]) {
        self.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
    }
}

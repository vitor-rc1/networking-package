//
//
//  Created by Vitor Conceicao.
//
//  github.com/vitor-rc1
//
//
    
import Foundation

public protocol APIEndpointProtocol {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var body: Data? { get }
    var queryItems: [URLQueryItem]? { get }
}

public extension APIEndpointProtocol {
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }

    var body: Data? {
        return nil
    }

    var queryItems: [URLQueryItem]? {
        return nil
    }
}

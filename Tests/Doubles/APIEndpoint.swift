//
//
//  Created by Vitor Conceicao.
//
//  github.com/vitor-rc1
//
//
    
import NetworkingInterfaces
import Foundation

struct APIEndpoint: APIEndpointProtocol {
    var baseURL: String
    var path: String
    var method: HTTPMethod
    var body: Data?
    var queryItems: [URLQueryItem]?
}

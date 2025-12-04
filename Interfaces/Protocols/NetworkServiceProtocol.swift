//
//
//  Created by Vitor Conceicao.
//
//  github.com/vitor-rc1
//
//
    
import Foundation

public protocol NetworkServiceProtocol {
    func request(endpoint: APIEndpointProtocol) async throws ->  (Data, HTTPURLResponse)
}

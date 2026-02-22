//
//
//  Created by Vitor Conceicao.
//
//  github.com/vitor-rc1
//
//
    
import Foundation

public protocol NetworkServiceProtocol: Sendable {
    @concurrent
    func request(endpoint: APIEndpointProtocol) async throws(NetworkError) ->  (Data, HTTPURLResponse)
}

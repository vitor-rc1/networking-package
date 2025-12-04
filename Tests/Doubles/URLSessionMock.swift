//
//
//  Created by Vitor Conceicao.
//
//  github.com/vitor-rc1
//
//
    
import Foundation
@testable import Networking

final class URLSessionMock: URLSessionInterface {
    enum Methods {
        case data
    }
    
    var calledMethods: [Methods] = []
    
    var urlRequestPassed: URLRequest?
    var dataTobeReturned: Data?
    var urlResponseToBeReturned: URLResponse?
    var shouldThrowError: Bool = false
    func data(for request: URLRequest, delegate: (any URLSessionTaskDelegate)?) async throws -> (Data, URLResponse) {
        calledMethods.append(.data)
        urlRequestPassed = request
        
        if shouldThrowError {
            throw NSError(domain: "", code: 500, userInfo: nil)
        }
        return (dataTobeReturned ?? Data(),
                urlResponseToBeReturned ?? URLResponse())
    }
}

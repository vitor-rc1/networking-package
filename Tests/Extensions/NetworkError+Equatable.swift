//
//
//  Created by Vitor Conceicao.
//
//  github.com/vitor-rc1
//
//
    
import Foundation
import NetworkingInterfaces

extension NetworkError: Equatable {
    public static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidURL, .invalidURL):
            return true
        case (.requestFailed, .requestFailed):
            return true
        case (.invalidResponse, .invalidResponse):
            return true
        case (.serverError(let lhsCode, _), .serverError(let rhsCode, _)):
            return lhsCode == rhsCode
        case (.decodingError, .decodingError):
            return true
        case (.unknownError, .unknownError):
            return true
        default:
            return false
        }
    }
}

//
//
//  Created by Vitor Conceicao.
//
//  github.com/vitor-rc1
//
//
    
import Foundation

public enum NetworkError: Error, LocalizedError {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case serverError(statusCode: Int, data: Data?)
    case decodingError(Error)
    case unknownError

    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The provided URL is invalid."
        case .requestFailed(let error):
            return "The network request failed: \(error.localizedDescription)"
        case .invalidResponse:
            return "Received an invalid response from the server."
        case .serverError(let statusCode, _):
            return "Server returned an error with status code: \(statusCode)."
        case .decodingError(let error):
            return "Failed to decode the response: \(error.localizedDescription)"
        case .unknownError:
            return "An unknown error occurred."
        }
    }
}

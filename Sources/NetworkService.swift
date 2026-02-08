//
//
//  Created by Vitor Conceicao.
//
//  github.com/vitor-rc1
//
//
    
import NetworkingInterfaces
import Foundation

public protocol URLSessionInterface {
    func data(for request: URLRequest,
              delegate: (any URLSessionTaskDelegate)?) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionInterface {}

public final class NetworkService: NetworkServiceProtocol {

    private let session: URLSessionInterface

    /// Initializes the network service.
    /// - Parameter session: A `URLSession` instance. Defaults to `URLSession.shared`.
    public init(session: URLSessionInterface = URLSession(configuration: .default)) {
        self.session = session
    }

    public func request(endpoint: APIEndpointProtocol) async throws -> (Data, HTTPURLResponse) {
        let fullPath = endpoint.baseURL + endpoint.path
        guard var url = URL(string: fullPath) else {
            throw NetworkError.invalidURL
        }
        
        if let queryItems = endpoint.queryItems, !queryItems.isEmpty {
            if #available(iOS 16.0, *) {
                url.append(queryItems: queryItems)
            } else {
                var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
                components?.queryItems = queryItems
                if let updatedURL = components?.url {
                    url = updatedURL
                }
            }
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.headers
        if let body = endpoint.body {
            request.httpBody = body
        }
        
        let data: Data
        let response: URLResponse
        
        do {
            (data, response) = try await session.data(for: request,
                                                      delegate: nil)
        } catch {
            throw NetworkError.requestFailed(error)
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        return (data, httpResponse)
    }
}

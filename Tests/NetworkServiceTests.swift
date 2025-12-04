//
//
//  Created by Vitor Conceicao.
//
//  github.com/vitor-rc1
//
//

import Testing
import Foundation
import NetworkingInterfaces

@testable import Networking

@Suite
struct NetworkServiceTests {
    @Test("GIVEN an invalid URL WHEN request is made THEN it throws invalidURL error")
    func test_requestWithInvalidUrl_throwsInvalidURLError() async throws {
        let (sut, _) = makeSut()
        let invalidEndpoint = APIEndpoint(
            baseURL: "https://example].com/",
            path: "/my path",
            method: .get)
        
        await #expect(throws: NetworkError.invalidURL) {
            try await sut.request(endpoint: invalidEndpoint)
        }
    }
    
    @Test("GIVEN a valid URL WHEN request is made THEN it calls URLSession data method")
    func test_requestWithValidUrl_callsURLSessionDataMethod() async throws {
        let (sut, urlSessionMock) = makeSut()
        let queryItems = [URLQueryItem(name: "key", value: "value")]
        let body: Data? = "\"body\"".data(using: .utf8)
        let validEndpoint = APIEndpoint(
            baseURL: "https://example.com",
            path: "/my-path",
            method: .get,
            body: body,
            queryItems: queryItems)
        let url = try #require(URL(string: "https://example.com/my-path?key=value"))
        urlSessionMock.urlResponseToBeReturned = HTTPURLResponse(url: url,
                                                                         statusCode: 200,
                                                                         httpVersion: nil,
                                                                         headerFields: nil)
        urlSessionMock.dataTobeReturned = "Bla".data(using: .utf8)
        var expectedURLRequest = URLRequest(url: url)
        expectedURLRequest.allHTTPHeaderFields = ["Content-Type": "application/json"]
        
        let (data, _) = try await sut.request(endpoint: validEndpoint)
        let result = String(data: data, encoding: .utf8)
        
        #expect(urlSessionMock.calledMethods == [.data])
        #expect(result == "Bla")
        #expect(urlSessionMock.urlRequestPassed == expectedURLRequest)
        #expect(urlSessionMock.urlRequestPassed?.httpBody == body)
    }
    
    @Test("GIVEN a invalid response WHEN request is made THEN it throws invalidResponse error")
    func test_requestWithInvalidResponse_throwsInvalidResponseError() async throws {
        let (sut, _) = makeSut()
        let validEndpoint = APIEndpoint(
            baseURL: "https://example.com",
            path: "/my-path",
            method: .get)
        
        
        await #expect(throws: NetworkError.invalidResponse) {
            try await sut.request(endpoint: validEndpoint)
        }
    }
    
    @Test("GIVEN a request failure WHEN request is made THEN it throws requestFailed error")
    func test_requestWithRequestFailure_throwsRequestFailedError() async throws {
        let (sut, urlSessionMock) = makeSut()
        let validEndpoint = APIEndpoint(
            baseURL: "https://example.com",
            path: "/my-path",
            method: .get
        )
        urlSessionMock.shouldThrowError = true
        let expectedError = NSError(domain: "", code: 500, userInfo: nil)
        await #expect(throws: NetworkError.requestFailed(expectedError)) {
            try await sut.request(endpoint: validEndpoint)
        }
    }
}

extension NetworkServiceTests {
    typealias SutAndDoubles = (
        sut: NetworkService,
        urlSessionMock: URLSessionMock
    )
    
    func makeSut() -> SutAndDoubles {
        let urlSessionMock = URLSessionMock()
        let sut = NetworkService(session: urlSessionMock)
        return (sut, urlSessionMock)
    }
}

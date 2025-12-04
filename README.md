# Networking Package

A lightweight, type-safe Swift networking package for iOS that provides a clean abstraction layer over URLSession. This package makes it easy to make HTTP requests with a protocol-based architecture.


## Features

- 🔧 **Protocol-Based Design**: Built on protocols for easy testing and customization
- 📱 **iOS Native**: Designed for iOS 18+ with modern async/await support
- 🧪 **Testable**: Includes mock implementations for easy unit testing
- 🛡️ **Type-Safe**: Full type safety with Swift's type system
- ⚙️ **HTTP Methods**: Support for GET, POST, PUT, PATCH, and DELETE
- 🔗 **Query Parameters**: Built-in support for URL query items
- 📝 **Custom Headers**: Easy header customization
- 💾 **Request Body**: Support for custom request bodies
- ❌ **Error Handling**: Comprehensive error types with descriptive messages

## Installation

Add this package to your Swift project by adding it to your `Package.swift`:

```swift
.package(url: "https://github.com/vitor-rc1/networking-package.git", branch: "main")
```

Then add it to your target dependencies:

```swift
.target(
    name: "YourTarget",
    dependencies: [.product(name: "Networking", package: "networking-package")]
)
```

## Quick Start

### 1. Create an API Endpoint

Conform to `APIEndpointProtocol`:

```swift
import NetworkingInterfaces

enum UserAPI: APIEndpointProtocol {
    case getUser(id: Int)
    case createUser(name: String, email: String)
    
    var baseURL: String {
        return "https://api.example.com"
    }
    
    var path: String {
        switch self {
        case .getUser(let id):
            return "/users/\(id)"
        case .createUser:
            return "/users"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getUser:
            return .get
        case .createUser:
            return .post
        }
    }
    
    var body: Data? {
        switch self {
        case .createUser(let name, let email):
            let json = ["name": name, "email": email]
            return try? JSONSerialization.data(withJSONObject: json)
        default:
            return nil
        }
    }
    
    var queryItems: [URLQueryItem]? {
        return nil
    }
}
```

### 2. Use the Network Service

```swift
import Networking

let networkService = NetworkService()

do {
    let endpoint = UserAPI.getUser(id: 1)
    let (data, response) = try await networkService.request(endpoint: endpoint)
    
    // Decode the response
    let user = try JSONDecoder().decode(User.self, from: data)
    print("User: \(user)")
} catch {
    print("Error: \(error)")
}
```

## API Reference

### NetworkService

Main service for making network requests.

```swift
public final class NetworkService: NetworkServiceProtocol {
    public init(session: URLSessionInterface = URLSession(configuration: .default))
    
    public func request(endpoint: APIEndpointProtocol) async throws -> (Data, HTTPURLResponse)
}
```

### APIEndpointProtocol

Protocol for defining API endpoints.

```swift
public protocol APIEndpointProtocol {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var body: Data? { get }
    var queryItems: [URLQueryItem]? { get }
}
```

**Default Implementations:**
- `headers`: Returns `["Content-Type": "application/json"]`
- `body`: Returns `nil`
- `queryItems`: Returns `nil`

### HTTPMethod

Enum representing HTTP methods.

```swift
public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}
```

### NetworkError

Comprehensive error types for network operations.

```swift
public enum NetworkError: Error, LocalizedError {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case serverError(statusCode: Int, data: Data?)
    case decodingError(Error)
    case unknownError
}
```

## Run Tests (iOS Simulator)

If you need to execute tests on an iOS simulator (for example when tests depend on runtime behavior only available on iOS), use `xcodebuild` and point to a valid simulator device name on your machine:

1. List available simulators:

```bash
xcrun simctl list devices
```

2. Pick a device name from the list (e.g. `iPhone 17`) and run:

```bash
xcodebuild -scheme Networking-Package -destination 'platform=iOS Simulator,name=iPhone 17' test
```

On CI (GitHub Actions) make sure the chosen simulator exists on the runner (or use an available device name). `xcodebuild test` will build and then run tests on the simulator; it returns a non-zero exit code if tests fail which causes the pipeline to fail.

## Package Structure

```
.
├── Interfaces/
│   ├── Models/
│   │   ├── HTTPMethod.swift
│   │   └── NetworkError.swift
│   └── Protocols/
│       ├── APIEndpointProtocol.swift
│       └── NetworkServiceProtocol.swift
├── Sources/
│   └── NetworkService.swift
├── Tests/
│   ├── NetworkServiceTests.swift
│   ├── Doubles/
│   │   ├── APIEndpoint.swift
│   │   └── URLSessionMock.swift
│   └── Extensions/
│       └── NetworkError+Equatable.swift
└── Package.swift
```

## Requirements

- iOS 18.0+
- Swift 6.0+

## Author

Created by [Vitor Conceição](https://github.com/vitor-rc1)

## License

This project is available under the MIT License.

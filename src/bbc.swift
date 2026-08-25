import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension URLSession {
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        return try await withCheckedThrowingContinuation { continuation in
            let task = self.dataTask(with: request) { data, response, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let data = data, let response = response {
                    continuation.resume(returning: (data, response))
                } else {
                    continuation.resume(throwing: URLError(.unknown))
                }
            }
            task.resume()
        }
    }
}

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

public class Bbc {
    private let api = "https://web-cdn.api.bbci.co.uk"
    private var headers: [String: String]
    
    public init() {
        self.headers = [
        "Accept":"*/*",
        "Connection":"keep-alive",
        "Accept-Encoding":"deflate, zstd",
        "Accept-Language":"en-US,en;q=0.9",
        "Host":"web-cdn.api.bbci.co.uk",
        "User-Agent":"Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36"
        ]

    }


    private func fetchJSON(from urlString: String,method: HTTPMethod = .get,body: Data? = nil,queryParameters: [String: String]? = nil) async throws -> Any {
        var urlComponents = URLComponents(string: urlString)
        if let queryParameters = queryParameters {
            urlComponents?.queryItems = queryParameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        guard let url = urlComponents?.url else {
            throw NSError(domain: "Invalid URL", code: -1)
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        if let body = body {
            request.httpBody = body
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONSerialization.jsonObject(with: data)
    }
    
    public func getNewsList(path: String) async throws -> Any {
        return try await fetchJSON(from: "\(api)/xd/page/content?path=\(path)")
    }
    
    public func getNewsByAssetId(type: String="live-header",assetId: String,language: String = "en-GB",showMedia: Bool=true) async throws -> Any {
        let urlString = "\(api)/wc-poll-data/container/\(type)"
        let queryParameters: [String: String] = [
            "assetId": assetId,
            "globalContainerPolling": "true",
            "isInternational": "true",
            "isTipoPage": "true",
            "language": language,
            "liveExperienceCrowdCount": "true",
            "showMedia": String(showMedia),
            "uasEnv": "live"
       ]
        return try await fetchJSON(from: urlString,method: .get,queryParameters: queryParameters)
    }
}

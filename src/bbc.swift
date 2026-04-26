public class Bbc {
    private let api = "https://bbci.co.uk"
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
    
    public func get_news_list(path: String)  async throws -> Any {
        guard let url = URL(string: "\(api)/xd/page/content?path=\(path)") else {
            throw NSError(domain: "Invalid URL", code: -1)
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            throw NSError(domain: "Parsing Error", code: -2)
        }
        return json
    }
    
    public func get_news_by_assetId(type: String = "live-header", assetId: String, language: String = "en-GB", showMedia: Bool = true)  async throws -> Any {
        let urlString = "\(api)/wc-poll-data/container/\(type)?assetId=\(assetId)&globalContainerPolling=true&isInternational=true&isTipoPage=true&language=\(language)&liveExperienceCrowdCount=true&showMedia=\(showMedia)&uasEnv=live"
        
        guard let url = URL(string: urlString) else {
            throw NSError(domain: "Invalid URL", code: -1)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let (data, _) = try await URLSession.shared.data(for: request)
        guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            throw NSError(domain: "Parsing Error", code: -2)
        }
        return json
    }
}

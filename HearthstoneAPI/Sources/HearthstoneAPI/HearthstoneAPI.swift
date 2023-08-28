@_exported import Foundation

public enum HearthstoneError: Swift.Error {
    case api(_ message: String)
}

fileprivate struct Problem: Decodable {
    private let info: String?
    private let message: String?
    private let messages: String?
    
    fileprivate var anyText: String {
        var text = ""
        
        if let info {
            text += info
        }
        
        if let messages {
            text += messages
        }
        
        if let message {
            text += message
        }
        
        return text
    }
}

fileprivate let host = "omgvamp-hearthstone-v1.p.rapidapi.com"
fileprivate let key = "5f1cac9225msh5c1f57d19ba6ddep1c622ajsn6a6cf94bdd3e"

fileprivate let cachePolicy: URLRequest.CachePolicy = .returnCacheDataElseLoad

func execute<T: Decodable>(_ string: String) async throws -> T {
    guard let url = URL(string: "https://\(host)/\(string)") else {
        throw HearthstoneError.api("Incorrect URL: \(string)")
    }
    
    var request = URLRequest(
        url: url, cachePolicy: cachePolicy, timeoutInterval: 60.0
    )
    
    let jsonDecoder = JSONDecoder()
    
    if let response = URLCache.shared.cachedResponse(for: request) {
        if (response.response as? HTTPURLResponse)?.statusCode == 200 {
            return try jsonDecoder.decode(T.self, from: response.data)
        }
    }
    
    request.setValue(key, forHTTPHeaderField: "X-RapidAPI-Key")
    
    let (data, response) = try await URLSession.shared.data(for: request)
    
    guard let httpResponse = response as? HTTPURLResponse else {
        throw HearthstoneError.api("Not is HTTP Response")
    }
    
    if httpResponse.statusCode != 200 {
        throw HearthstoneError.api(
            try jsonDecoder.decode(Problem.self, from: data).anyText
        )
    }
    
    URLCache.shared.storeCachedResponse(
        .init(response: response, data: data), for: request
    )
    
    return try jsonDecoder.decode(T.self, from: data)
}

public func HearthstoneGetData(url: URL) async throws -> Data {
    try await URLSession.shared.data(from: url).0
}

//
//  URLSessionAPIClient.swift
//  Ricky&Morty
//
//  Created by Ibrahim El-geddawy on 24/10/2024.
//

import Foundation

class URLSessionAPIClient<EndpointType: APIEndpoint>: APIClient {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func request<T: Decodable>(_ endpoint: EndpointType) async throws -> T {
        var urlComponents = URLComponents(url: endpoint.baseURL.appendingPathComponent(endpoint.path), resolvingAgainstBaseURL: false)
        
        // Add parameters to the request if they exist
        if let parameters = endpoint.parameters {
            var queryItems: [URLQueryItem] = []
            for (key, value) in parameters {
                if let value = value {
                    queryItems.append(URLQueryItem(name: key, value: "\(value)"))
                }
            }
            urlComponents?.queryItems = queryItems
        }
        
        guard let url = urlComponents?.url else {
            throw NetworkError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        endpoint.headers?.forEach { request.addValue($0.value, forHTTPHeaderField: $0.key) }
        
        
        print(request.url?.absoluteString)
        // Perform the network request
        let (data, response) = try await session.data(for: request)
        
        // Validate HTTP response
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidData
        }
        
        guard 200...299 ~= httpResponse.statusCode else {
            throw NetworkError.invalidStatusCode(statusCode: httpResponse.statusCode)
        }
        print(String(data: data, encoding: .utf8) ?? "Failed to convert data to string")
        
        // Decode the response
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw NetworkError.jsonParsingFailure
        }
    }
}

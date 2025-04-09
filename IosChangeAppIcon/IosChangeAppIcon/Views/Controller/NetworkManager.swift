//
//  NetworkManager.swift
//  Hike
//
//  Created by Wilton Garcia on 01/04/25.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
    case serverError(statusCode: Int)
    case unknownError
}

enum apiURL {
    static let apiary = "https://private-bfbc1-poc47.apiary-mock.com"
}

enum NetworkEndpoint: String {
    case initialConfig = "/initialConfig"
    case newIcons = "/getNewIcons"
}

class NetworkManager {
    
    static let shared = NetworkManager()
    private let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func request<T: Decodable>(
        endoint: NetworkEndpoint,
        method: HTTPMethod = .get,
        body: Data? = nil,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        guard let url = URL(string: "\(apiURL.apiary)\(endoint.rawValue)") else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = body
        

        
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.unknownError))
                print("Request error: \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.unknownError))
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.serverError(statusCode: httpResponse.statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let decodedObject = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedObject))
            } catch {
                print("Decoding error: \(error)")
                completion(.failure(.decodingError))
            }
        }
        
        task.resume()
    }
    
    // Método conveniente para requisições GET com parâmetros de query
    func get<T: Decodable>(
        endoint: NetworkEndpoint,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        request(endoint: endoint, method: .get, completion: completion)
    }
    
    // Método conveniente para requisições POST com corpo JSON
    func post<T: Decodable>(
        urlString: String,
        body: [String: Any]? = nil,
        headers: [String: String]? = nil,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        var requestBody: Data?
        
        if let body = body {
            do {
                requestBody = try JSONSerialization.data(withJSONObject: body, options: [])
            } catch {
                completion(.failure(.unknownError))
                return
            }
        }
        
        var finalHeaders = headers ?? [:]
        if requestBody != nil {
            finalHeaders["Content-Type"] = "application/json"
        }
        
        request(
            endoint: .initialConfig,
            method: .post,
            body: requestBody,
            completion: completion
        )
    }
}

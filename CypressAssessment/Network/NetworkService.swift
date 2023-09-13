//
//  NetworkService.swift
//  CypressAssessment
//
//  Created by James Anyanwu on 13/09/2023.
//

import Foundation
import Foundation

enum NetworkError: Error {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case decodingFailed(Error)
}

enum Route {
    case albums
    case photos
}
extension Route {
    static let basePath = "https://jsonplaceholder.typicode.com/"
    
    var path: String {
        switch self {
        case .albums:
            return "albums"
        case .photos:
            return "photos"
        }
    }
}
class NetworkService {
    static let shared = NetworkService()
    
    private init() {
        
    }
    func fetchData<T: Codable>(route: Route, completion: @escaping (Result<T, NetworkError>) -> Void) {
        
        guard let url = URL(string: Route.basePath + route.path) else {
            completion(.failure(.invalidURL))
            return
        }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(.requestFailed(error)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidResponse))
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(.decodingFailed(error)))
            }
        }.resume()
    }
}

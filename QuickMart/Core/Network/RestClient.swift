//
//  RestClient.swift
//  QuickMart
//
//  Created by siam on 05/07/2026.
//

import Foundation

class RestClient:RestClientProtocol{
    func request<T: Decodable>(baseUrl: String, endpoint: String) async throws -> T{
        
        guard let url = URL(string:"\(baseUrl)\(endpoint)") else {
            throw NetworkError.invalidURL
        }
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw URLError(.badServerResponse)
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
               throw NetworkError.requestFailed(statusCode: httpResponse.statusCode, data: data)
            }
            
            return try JSONDecoder().decode(T.self, from: data)
            
        } catch let decodingError as DecodingError {
            throw NetworkError.decodingFailed(decodingError)
        } catch let error as NetworkError {
            throw error
        } catch {
            throw error
        }
    }
    
    
}

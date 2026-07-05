//
//  RestClientProtocol.swift
//  QuickMart
//
//  Created by siam on 05/07/2026.
//

protocol RestClientProtocol {
    func request<T:Decodable>(baseUrl:String,endpoint:String) async throws->T
}

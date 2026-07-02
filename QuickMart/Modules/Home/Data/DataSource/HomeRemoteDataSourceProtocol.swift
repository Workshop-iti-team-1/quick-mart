//
//  HomeRemoteDataSourceProtocol.swift
//  QuickMart
//
//  Created by Alaa Ayman on 02/07/2026.
//


import Foundation
import Combine

protocol HomeRemoteDataSourceProtocol {
    func fetchCollections(first: Int) -> AnyPublisher<[CollectionModel], Error>
}

//
//  NetworkService.swift
//  PhotoCollection
//
//  Created by SasikumarSubramaniyam on 21/04/24.
//

import Foundation
import Combine

// MARK: - fetching API Data protocol
protocol UnsplashServiceProtocol: AnyObject {
    var networkService: NetworkProtocol { get }
    func fetchPhotosList(with params: [String: Any]) -> AnyPublisher<[UnsplashPhoto], Error>
}

// MARK: - fetching API Data
final class NetworkService: UnsplashServiceProtocol {
        
    // MARK: - Properties
    var networkService: NetworkProtocol
    
    // MARK: Initializer with dependency
    init(networkService: NetworkProtocol = NetworkRequest()) {
        self.networkService = networkService
    }
    
    // This function used to fetch the photos list data based on URL with the help of Network Service
    func fetchPhotosList(with params: [String: Any]) -> AnyPublisher<[UnsplashPhoto], Error> {
        let newsPublisher: AnyPublisher<[UnsplashPhoto], Error> = networkService.executeApiRequest(type: [UnsplashPhoto].self, params: params)
        return newsPublisher.map { $0 }.eraseToAnyPublisher()
    }
    
}

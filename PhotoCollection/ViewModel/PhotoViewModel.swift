//
//  PhotoViewModel.swift
//  PhotoCollection
//
//  Created by SasikumarSubramaniyam on 19/04/24.
//

import Foundation
import Combine

class PhotoViewModel {
    
    // MARK: Properties
    private var photos = [UnsplashPhoto]()
    private var networkService: UnsplashServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Output
    var numberOfRows: Int {
        photos.count
    }
    
    // MARK: Initializer with dependency
    init(networkService: UnsplashServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    // This function used to fetch the image list data from api.
    func getImageList(with pageNumber: Int,
                      completionHandler: @escaping(_ isSuccess: Bool?, _ error: ApiError?) -> ()) {
        if Reachability.isConnectedToNetwork() {
            networkService.fetchPhotosList(with: prepareParameters(with: pageNumber))
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    switch completion {
                    case .failure(let error):
                        completionHandler(false, ApiError.request(message: error.localizedDescription))
                    case .finished:
                        break
                    }
                } receiveValue: { [weak self] photosList in
                    if !photosList.isEmpty {
                        self?.photos.append(contentsOf: photosList)
                        completionHandler(true, nil)
                    }
                }
                .store(in: &cancellables)
        } else {
            completionHandler(nil, ApiError.network(message: Constants.noInternetConnection))
        }
        
    }
    
    func prepareParameters(with page: Int) -> [String: Any] {
        return ["page": page, "per_page": 50]
    }
    
    
    func fetchPhotoURL(with index: Int) -> String? {
        return photos[index].urls?[UnsplashPhoto.URLKind.thumb.rawValue]
    }
}


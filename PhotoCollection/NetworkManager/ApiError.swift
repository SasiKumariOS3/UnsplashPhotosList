//
//  ApiError.swift
//  PhotoCollection
//
//  Created by SasikumarSubramaniyam on 20/04/24.
//

import Foundation

// MARK: - All Api error's are handling here
enum ApiError: Error {
    case request(message: String)
    case network(message: String)
    case other(message: String)
    
    static func map(_ error: Error) -> ApiError {
        return (error as? ApiError) ?? .other(message: error.localizedDescription)
    }
    
}

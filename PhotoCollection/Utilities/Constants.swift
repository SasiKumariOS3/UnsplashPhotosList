//
//  Constants.swift
//  PhotoCollection
//
//  Created by SasikumarSubramaniyam on 20/04/24.
//

import Foundation


struct Constants {
    // MARK: - API url
    let apiURL = "https://api.unsplash.com/"
    
    // MARK: - Keys
    let accessKey = "PVNQPxUpklDI1Cbolg3T4Owix_9QVMrwVOoSzESRgYw"
    
    // MARK: - Alert messages
    static let ok = "Ok"
    static let error = "Error"
    static let alertMessage = "Loading..."
    static let noInternetConnection = "No InternetConnection. please try again.."
    
    // MARK: - File Identifier
    static let nibId = "PhotoViewCell"
    
    // MARK: - Cell Identifier
    static let cellId = "PhotoCell"

    // MARK: - Image Names
    static let placeHolder = "placeHolder"
}

// API Request Methods
enum Method: String {
    case get, post, put, delete
}

// API QueryFormat
enum QueryFormat {
    case json
    case urlEncoded
}

// API QueryType
enum QueryType {
    case body
    case path
}

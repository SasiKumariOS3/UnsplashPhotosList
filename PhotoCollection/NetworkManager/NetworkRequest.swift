//
//  NetworkRequest.swift
//  PhotoCollection
//
//  Created by SasikumarSubramaniyam on 19/04/24.
//

import Foundation
import Combine

protocol NetworkProtocol: AnyObject {
    typealias Parameters = [String: Any]
    func executeApiRequest<T>(type: T.Type, params: Parameters?) -> AnyPublisher<T, Error> where T: Decodable
}

final class NetworkRequest: NetworkProtocol {
   
    var endpoint: String { return "/photos" }
    var method: Method { return .get }
    var format: QueryFormat { return .urlEncoded }
    var type: QueryType { return .path }
    var timeoutInterval = 30.0
    
    // This function used to execute the api Request
    func executeApiRequest<T>(type: T.Type, params: Parameters?) -> AnyPublisher<T, Error> where T : Decodable {
        guard var request = try? prepareURLRequest(params) else {
            return Fail(error: ApiError.request(message: "Invalid Url")).eraseToAnyPublisher()
        }
        
        request.allHTTPHeaderFields = prepareHeaders()
        request.httpMethod = method.rawValue
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    // This function used to prepare the URL components
    private func prepareURLComponents() -> URLComponents? {
        guard let apiURL = URL(string: Constants().apiURL) else {
            return nil
        }
        var urlComponents = URLComponents(url: apiURL, resolvingAgainstBaseURL: true)
        urlComponents?.path = endpoint
        return urlComponents
    }
    
    // This function used to prepare the headers
    private func prepareHeaders() -> [String: String]? {
        var headers = [String: String]()
        headers["Authorization"] = "Client-ID \(Constants().accessKey)"
        return headers
    }
    
    // This function used to organize query parameters
    private func queryParameters(_ parameters: [String: Any]?, urlEncoded: Bool = false) -> String {
        var allowedCharacterSet = CharacterSet.alphanumerics
        allowedCharacterSet.insert(charactersIn: ".-_")
        
        var query = ""
        parameters?.forEach { key, value in
            let encodedValue: String
            if let value = value as? String {
                encodedValue = urlEncoded ? value.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? "" : value
            } else {
                encodedValue = "\(value)"
            }
            query = "\(query)\(key)=\(encodedValue)&"
        }
        return query
    }
    
    // This function used for prepare url request
    private func prepareURLRequest(_ params: Parameters?) throws -> URLRequest {
        
        guard let url = prepareURLComponents()?.url else {
            throw  ApiError.request(message: "Invalid Url")
        }
        
        switch type {
        case .body:
            var mutableRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: timeoutInterval)
            if let parameters = params {
                switch format {
                case .json:
                    mutableRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
                case .urlEncoded:
                    mutableRequest.httpBody = queryParameters(parameters, urlEncoded: true).data(using: .utf8)
                }
            }
            return mutableRequest
            
        case .path:
            var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
            components.query = queryParameters(params)
            return URLRequest(url: components.url!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: timeoutInterval)
        }
    }
}

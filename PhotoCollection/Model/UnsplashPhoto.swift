//
//  UnsplashPhoto.swift
//  PhotoCollection
//
//  Created by SasikumarSubramaniyam on 19/04/24.
//

import Foundation


public struct UnsplashPhoto: Codable {
    
    public enum URLKind: String, Codable {
        case raw
        case full
        case regular
        case small
        case thumb
    }
    public let urls: [String: String]?
    public let description: String?
    
    private enum CodingKeys: String, CodingKey {
        case urls
        case description
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        urls = try container.decodeIfPresent([String: String].self, forKey: .urls)
    }
}

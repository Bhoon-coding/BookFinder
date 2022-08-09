//
//  EndPointType.swift
//  BookFinder
//
//  Created by BH on 2022/08/09.
//

import Foundation

protocol EndPointType {
    
    var baseURL: String { get }
    var path: String { get }
    var query: [URLQueryItem]? { get }
    
    func asURLRequest() -> URLRequest?
    
}

extension EndPointType {
    
    func asURLRequest() -> URLRequest? {
        var components = URLComponents(string: baseURL)
        components?.path = path
        components?.queryItems = query
        
        guard let url = components?.url else {
            return nil
        }
        
        let urlRequest = URLRequest(url: url)
        
        return urlRequest
    }
    
}

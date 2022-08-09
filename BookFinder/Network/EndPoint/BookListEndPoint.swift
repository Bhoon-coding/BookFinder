//
//  BookListEndPoint.swift
//  BookFinder
//
//  Created by BH on 2022/08/09.
//

import Foundation

class BookListEndPoint: EndPointType {
    
    var baseURL: String {
        return "https://www.googleapis.com"
    }
    
    var path: String {
        return "/books/v1/volumes"
    }
    
    var query: [URLQueryItem]? {
        return [URLQueryItem(name: "key", value: apiKey),
                URLQueryItem(name: "startIndex", value: "\(startIndex)"),
                URLQueryItem(name: "q", value: "\(searchText)")]
    }
    
    var apiKey: String {
        return Bundle.main.apiKey
    }
    
    var searchText: String
    var startIndex: Int
    
    init(searchText: String,
         startIndex: Int) {
        self.searchText = searchText
        self.startIndex = startIndex
    }

}

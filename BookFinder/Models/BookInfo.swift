//
//  BookInfo.swift
//  BookFinder
//
//  Created by BH on 2022/08/11.
//

import Foundation

struct BookInfo: Decodable {
    
    let uuid = UUID()
    let title: String
    let authors: [String]?
    let publishedDate: String?
    let imageLinks: BookImage?
    let infoLink: String
    
}

extension BookInfo: Hashable {
    
    static func == (lhs: BookInfo, rhs: BookInfo) -> Bool {
        return lhs.uuid == rhs.uuid
    }
    
}

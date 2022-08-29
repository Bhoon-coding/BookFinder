//
//  BookList.swift
//  BookFinder
//
//  Created by BH on 2022/08/11.
//

import Foundation

struct BookList: Decodable {
    
    let uuid = UUID()
    let id: String
    let bookInfo: BookInfo
    
    enum CodingKeys: String, CodingKey {
        
        case uuid, id
        case bookInfo = "volumeInfo"
        
    }
    
}

extension BookList: Hashable {
    
    static func == (lhs: BookList, rhs: BookList) -> Bool {
        return lhs.uuid == rhs.uuid
    }
    
}

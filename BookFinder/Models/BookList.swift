//
//  BookList.swift
//  BookFinder
//
//  Created by BH on 2022/08/11.
//

import Foundation

struct BookList: Decodable, Hashable {
    
    static func == (lhs: BookList, rhs: BookList) -> Bool {
        return lhs.uuid == rhs.uuid
    }
    
    var uuid = UUID()
    let id: String
    let bookInfo: BookInfo
    
    enum CodingKeys: String, CodingKey {
        
        case uuid, id
        case bookInfo = "volumeInfo"
        
    }
    
}

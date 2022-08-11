//
//  BookList.swift
//  BookFinder
//
//  Created by BH on 2022/08/11.
//

import Foundation

struct BookList: Decodable {
    
    let id: String
    let bookInfo: BookInfo
    
    enum CodingKeys: String, CodingKey {
        
        case id
        case bookInfo = "volumeInfo"
        
    }
    
}

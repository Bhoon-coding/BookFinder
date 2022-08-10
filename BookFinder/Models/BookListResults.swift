//
//  BookListResults.swift
//  BookFinder
//
//  Created by BH on 2022/08/09.
//

struct BookListResults: Decodable {
    
    let totalItems: Int
    let items: [BookList]
    
}

struct BookList: Decodable {
    
    let id: String
    let bookInfo: BookInfo
    
    enum CodingKeys: String, CodingKey {
        
        case id
        case bookInfo = "volumeInfo"
        
    }
    
}

struct BookInfo: Decodable {
    
    let title: String
    let authors: [String]?
    let publishedDate: String
    let imageLinks: BookImage
    let infoLink: String
    
}

struct BookImage: Decodable {
    
    let thumbnail: String
    
}

//
//  BookList.swift
//  BookFinder
//
//  Created by BH on 2022/08/09.
//

struct BookListResults {
    
    var totalItems: Int
    var items: [BookList]
    
}

struct BookList {
    
    var id: String
    var bookInfo: BookInfo
    var imageLinks: BookImage
    var infoLink: String
    
    enum CodingKeys: String, CodingKey {
        
        case volumeInfo = "bookInfo"
        
    }
    
}

struct BookInfo {
    
    var title: String
    var authors: [String]
    var publishedDate: String
    
}

struct BookImage {
    
    var thumbnail: String
    
}

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

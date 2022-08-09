//
//  BookAPIProvider.swift
//  BookFinder
//
//  Created by BH on 2022/08/09.
//

import Foundation

protocol BookListAPIProviderType {
    
    func fetchBooks(
        with searchText: String,
        to startIndex: Int,
        completion: @escaping (Result<BookListResults, Error>) -> Void
    )
    
}

struct BookListAPIProvider: BookListAPIProviderType {
    
    let networkRequester: NetworkRequesterType
    
    func fetchBooks(
        with searchText: String,
        to index: Int,
        completion: @escaping (Result<BookListResults, Error>) -> Void
    ) {
        let bookListEndPoint = BookListEndPoint(searchText: searchText, startIndex: index)
        networkRequester.request(to: bookListEndPoint) { result in
            switch result {
            case .success(let data):
                let decoder = JSONDecoder()
                guard let decodedData = try? decoder.decode(BookListResults.self, from: data) else {
                    return
                }
                completion(.success(decodedData))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
     
}

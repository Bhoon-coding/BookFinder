//
//  SearchBookViewModel.swift
//  BookFinder
//
//  Created by BH on 2022/08/10.
//

import Foundation
import UIKit.UIImage

public class SearchBookViewModel {
    
    let searchedBookTotalCount: Observable<Int> = Observable(0)
    let startIndex: Observable<Int> = Observable(0)
    let searchedTitle: Observable<String> = Observable("")
    var bookList: Observable<[BookList]> = Observable([])
    var isLoading: Observable<Bool> = Observable(false)
    var noResult: Observable<Bool> = Observable(false)
    
    private let bookListAPIProvider = BookListAPIProvider(networkRequester: NetworkRequester())
    private let bookImageProvider = BookImageProvider(networkRequester: NetworkRequester())
    
    func fetchBookList(
        with searchText: String
    ) {
        isLoading.value = true
        bookListAPIProvider.fetchBooks(
            with: searchText,
            from: startIndex.value,
            completion: { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                    
                case .success(let data):
                    guard let items = data.items else {
                        self.noResult.value = true
                        return
                    }
                    self.searchedBookTotalCount.value = data.totalItems
                    self.bookList.value = items
                    self.startIndex.value += 10
                    self.searchedTitle.value = searchText
                    self.isLoading.value = false
                    
                case .failure(let error):
                    print(error.localizedDescription)
                    self.isLoading.value = false
                }
            })
    }
    
    func fetchAnotherBookList(
        searchedTitle: String,
        startIndex: Int
    ) {
        isLoading.value = true
        bookListAPIProvider.fetchBooks(
            with: searchedTitle,
            from: startIndex,
            completion: { [weak self] result in
                guard let self = self else { return }

                switch result {
                    
                case .success(let data):
                    guard let items = data.items else {
                        self.noResult.value = true
                        return
                    }
                    self.bookList.value += items
                    self.startIndex.value += 10
                    self.isLoading.value = false
                    
                case .failure(let error):
                    print(error.localizedDescription)
                    self.isLoading.value = false
                }
            }
        )
        
    }
    
    func fetchImage(bookImageURL: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        bookImageProvider.fetchImage(with: bookImageURL) {
            result in
            switch result {
                
            case .success(let image):
                completion(.success(image))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

}


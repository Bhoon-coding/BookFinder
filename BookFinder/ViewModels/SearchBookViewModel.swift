//
//  SearchBookViewModel.swift
//  BookFinder
//
//  Created by BH on 2022/08/10.
//

import Foundation
import UIKit.UIImage

public class SearchBookViewModel {
    
    let searchedBookTotalCount: Box<Int> = Box(0)
    let startIndex: Box<Int> = Box(0)
    let searchedTitle: Box<String> = Box("")
    var bookList: Box<[BookList]> = Box([])
    var bookImage: Box<UIImage> = Box(UIImage())
    var isLoading: Box<Bool> = Box(false)
    
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
                    self.searchedBookTotalCount.value = data.totalItems
                    self.bookList.value = data.items
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
                    self.bookList.value += data.items
                    self.startIndex.value += 10
                    self.isLoading.value = false
                    
                case .failure(let error):
                    print(error.localizedDescription)
                    self.isLoading.value = false
                }
            }
        )
        
    }
    
    func fetchImage(bookImageURL: String, completion: @escaping () -> Void) {
        bookImageProvider.fetchImage(with: bookImageURL) { [weak self] result in
            guard let self = self else { return }
            switch result {
                
            case .success(let image):
                self.bookImage.value = image
                completion()
                
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }
    }
    
}


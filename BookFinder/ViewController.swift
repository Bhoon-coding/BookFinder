//
//  ViewController.swift
//  BookFinder
//
//  Created by BH on 2022/08/09.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Properties
    
    private var bookListAPIProvider: BookListAPIProviderType?
    var bookList: [BookListResults] = []

    // MARK: - LifeCycle
    
    static func instantiate(
        with bookListAPIProvider: BookListAPIProviderType
    ) -> ViewController {
        let viewController = ViewController()
        viewController.bookListAPIProvider = bookListAPIProvider
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchBookList()
    }

}

// MARK: - Fetch BookList Data extension

extension ViewController {
    
    private func fetchBookList() {
        bookListAPIProvider?.fetchBooks(with: "time", to: 1, completion: { result in
            switch result {
            case .success(let bookList):
                dump(bookList)
            case .failure(let error):
                print("네트워킹 실패: \(error.localizedDescription)")
            }
        })
    }
    
}


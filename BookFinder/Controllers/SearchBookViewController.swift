//
//  ViewController.swift
//  BookFinder
//
//  Created by BH on 2022/08/09.
//

import UIKit

class SearchBookViewController: UIViewController {
    
    // MARK: - UIProperties
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController()
        searchController.searchBar.placeholder = Text.searchBarPlaceholder
        searchController.automaticallyShowsCancelButton = false
        return searchController
    }()
    
    // MARK: - Properties
    
    private var bookListAPIProvider: BookListAPIProviderType?
    var bookList: [BookListResults] = []

    // MARK: - LifeCycle 
    
    static func instantiate(
        with bookListAPIProvider: BookListAPIProviderType
    ) -> SearchBookViewController {
        let viewController = SearchBookViewController()
        viewController.bookListAPIProvider = bookListAPIProvider
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupSearchController()
    }
    
    private func setupSearchController() {
        self.navigationItem.searchController = searchController
        self.navigationItem.title = Text.navigationTitle
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchResultsUpdater = self
    }
    
}

// MARK: - Fetch BookList Data extension

extension SearchBookViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        if text.count >= 2 {
            fetchBookList(with: text)
        }
    }
    
    
    private func fetchBookList(with bookTitle: String) {
        bookListAPIProvider?.fetchBooks(with: bookTitle, to: 1, completion: { result in
            switch result {
            case .success(let bookList):
                dump(bookList)
            case .failure(let error):
                print("네트워킹 실패: \(error.localizedDescription)")
            }
        })
    }
    
}

// MARK: - NameSpaces

extension SearchBookViewController {
    
    private enum Text {
        
        static let searchBarPlaceholder: String = "찾으시려는 책을 검색 해보세요."
        static let navigationTitle: String = "책 검색"
        
    }
    
}

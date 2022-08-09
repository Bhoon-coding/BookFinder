//
//  ViewController.swift
//  BookFinder
//
//  Created by BH on 2022/08/09.
//

import UIKit

import SnapKit

final class SearchBookViewController: UIViewController {
    
    // MARK: - UIProperties
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = Text.searchBarPlaceholder
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.automaticallyShowsCancelButton = false
        return searchController
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(
            SearchBookCollectionViewCell.self,
            forCellWithReuseIdentifier: SearchBookCollectionViewCell.identifier
        )
        return collectionView
    }()
    
    // MARK: - Properties
    
    private var bookListAPIProvider: BookListAPIProviderType?
    private var bookImageProvider: BookImageProviderType?
    
    let sectionInsets = Style.sectionInsets
    var searchedBookTotalCount: Int = 0
    var bookList: [BookList] = []

    // MARK: - LifeCycle 
    
    static func instantiate(
        with bookListAPIProvider: BookListAPIProviderType,
        _ bookImageProvider: BookImageProviderType
    ) -> SearchBookViewController {
        let viewController = SearchBookViewController()
        viewController.bookListAPIProvider = bookListAPIProvider
        viewController.bookImageProvider = bookImageProvider
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupCollectionView()
        setupConstraints()
        setupSearchController()
    }
    
    private func setupSearchController() {
        self.navigationItem.searchController = searchController
        self.navigationItem.title = Text.navigationTitle
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.hidesSearchBarWhenScrolling = false
//        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
    }
    
}

extension SearchBookViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchController.searchBar.text else { return }
        fetchBookList(with: text)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
            bookList = []
            DispatchQueue.main.async { [weak self] in
                self?.collectionView.reloadData()
            }
        }
    }
    
    private func fetchBookList(with bookTitle: String) {
        bookListAPIProvider?.fetchBooks(with: bookTitle, to: 1, completion: { result in
            switch result {
            case .success(let data):
                self.searchedBookTotalCount = data.totalItems
                self.bookList = data.items
                dump(data)
                DispatchQueue.main.async { [weak self] in
                    self?.collectionView.reloadData()
                }
            case .failure(let error):
                print("네트워킹 실패: \(error.localizedDescription)")
            }
        })
    }
    
}

// MARK: - Fetch BookList Data extension

//extension SearchBookViewController: UISearchResultsUpdating {
//    func updateSearchResults(for searchController: UISearchController) {
//        guard let text = searchController.searchBar.text else { return }
//        if text.count >= 2 {
//            fetchBookList(with: text)
//        }
//    }
//
    
//
//}

// MARK: - CollectionView Layout extension

extension SearchBookViewController {
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        [collectionView].forEach {
            view.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        setupConstraintsOfCollectionView()
    }
    
    private func setupConstraintsOfCollectionView() {
        collectionView.snp.makeConstraints {
            $0.leading.top.trailing.bottom.equalToSuperview()
        }
    }
    
}

extension SearchBookViewController: UICollectionViewDataSource {
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return bookList.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SearchBookCollectionViewCell.identifier,
            for: indexPath
        ) as? SearchBookCollectionViewCell else {
            return UICollectionViewCell()
        }
        let book: BookList = bookList[indexPath.item]
        let bookImageURL = book.bookInfo.imageLinks.thumbnail
        
        cell.setupCell(book: book)
        
        bookImageProvider?.fetchImage(with: bookImageURL, completion: { result in
            switch result {
            case .success(let image):
                cell.setupImage(image: image)
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
        
        return cell
    }

}

extension SearchBookViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width: CGFloat = collectionView.frame.width
        let height: CGFloat = collectionView.frame.height
        let itemsPerRow: CGFloat = 2
        let widthPadding = sectionInsets.left * (itemsPerRow + 1)
        let itemsPerColumn: CGFloat = 3
        let heightPadding = sectionInsets.top * (itemsPerColumn + 1)
        let cellWidth = (width - widthPadding) / itemsPerRow
        let cellHeight = (height - heightPadding) / itemsPerColumn
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return sectionInsets
    }
    
}

// MARK: - NameSpaces

extension SearchBookViewController {
    
    private enum Style {
        static let sectionInsets: UIEdgeInsets = .init(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    private enum Text {
        static let searchBarPlaceholder: String = "찾으시려는 책을 검색 해보세요."
        static let navigationTitle: String = "책 검색"
    }
    
}

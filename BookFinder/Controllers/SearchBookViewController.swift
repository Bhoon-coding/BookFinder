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
    
    private lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.hidesWhenStopped = true
        spinner.style = .large
        spinner.color = .systemBlue
        return spinner
    }()
    
    // MARK: - Properties
    
    private let viewModel = SearchBookViewModel()
    
    private let sectionInsets = Style.sectionInsets
    private var searchedBookTotalCount: Int = 0
    private var startIndex: Int = 0
    private var searchedTitle: String = ""
    private var bookImage: UIImage = UIImage()
    private var bookList: [BookList] = []
    private var noResult: Bool = false

    // MARK: - LifeCycle 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupView()
        setupConstraints()
        setupSearchController()
        setBindings()
    }
    
}

// MARK: - Views setup extension

extension SearchBookViewController {
    
    private func setupView() {
        setupCollectionView()
        [collectionView,
        spinner].forEach {
            view.addSubview($0)
        }
    }
    
    private func setupSearchController() {
        self.navigationItem.searchController = searchController
        self.navigationItem.title = Text.navigationTitle
        self.navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.delegate = self
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
}

// MARK: - Constraints extension

extension SearchBookViewController {
    
    private func setupConstraints() {
        setupConstraintsOfCollectionView()
        setupConstraintsOfSpinner()
    }
    
    private func setupConstraintsOfCollectionView() {
        collectionView.snp.makeConstraints {
            $0.leading.top.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setupConstraintsOfSpinner() {
        spinner.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
}

// MARK: - Data Binding

extension SearchBookViewController {
    
    private func setBindings() {
        viewModel.searchedBookTotalCount.bind { [weak self] searchedBookTotalCount in
            guard let self = self else { return }
            self.searchedBookTotalCount = searchedBookTotalCount
            
            DispatchQueue.main.async {
                if self.searchedBookTotalCount == 0 {
                    self.navigationItem.title = Text.navigationTitle
                } else {
                    self.navigationItem.title = Text.navigationSearchedTitle + "(\(self.searchedBookTotalCount))"
                }
            }
        }
        
        viewModel.searchedTitle.bind { [weak self] searchedTitle in
            self?.searchedTitle = searchedTitle
        }
        
        viewModel.startIndex.bind { [weak self] startIndex in
            self?.startIndex = startIndex
        }
        
        viewModel.bookImage.bind { [weak self] bookImage in
            self?.bookImage = bookImage
        }
        
        viewModel.bookList.bind { [weak self] bookList in
            self?.bookList = bookList
            
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
        
        viewModel.isLoading.bind { [weak self] isLoading in
            DispatchQueue.main.async {
                if isLoading {
                    self?.spinner.startAnimating()
                } else {
                    self?.spinner.stopAnimating()
                }
            }
            
        }
        
        viewModel.noResult.bind { [weak self] noResult in
            DispatchQueue.main.async {
                if noResult {
                    self?.spinner.stopAnimating()
                }
            }
        }
    }
    
}

// MARK: - CollectionView DataSource extension

extension SearchBookViewController: UICollectionViewDataSource {
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return viewModel.bookList.value.count
    }
    
     func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        if indexPath.item == (viewModel.bookList.value.count - 1) {
            viewModel.fetchAnotherBookList(
                searchedTitle: searchedTitle,
                startIndex: startIndex
            )
        }
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
        let bookList = viewModel.bookList.value[indexPath.item]
        let bookImageURL = bookList.bookInfo.imageLinks?.thumbnail ?? Style.emptyImageURL
       
        cell.setupCell(bookList: bookList)
        viewModel.fetchImage(bookImageURL: bookImageURL) {
            cell.setupImage(image: self.bookImage)
        }
        return cell
    }

}

// MARK: - CollectionView DelegateFlowLayout extension

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

// MARK: - CollectionView Delegate extension

extension SearchBookViewController: UICollectionViewDelegate {
    
     func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let backBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = .black
        navigationItem.backBarButtonItem = backBarButtonItem
        let book: BookList = bookList[indexPath.item]
        let bookDetailViewController = BookDetailViewController(book: book)
        navigationController?.pushViewController(bookDetailViewController, animated: true)
    }
    
}

// MARK: - SearchBar Delegate extension

extension SearchBookViewController: UISearchBarDelegate {
    
     func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
            viewModel.bookList.value = []
            viewModel.startIndex.value = 0
            viewModel.isLoading.value = false
            DispatchQueue.main.async { [weak self] in
                self?.navigationItem.title = Text.navigationTitle
            }
        }
    }
    
     func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        guard let searchText = searchController.searchBar.text else { return }

        if searchText.count > 1 {
            viewModel.fetchBookList(with: searchText)
        }
    }
    
}

// MARK: - NameSpaces

extension SearchBookViewController {
    
    private enum Style {
        static let sectionInsets: UIEdgeInsets = .init(top: 10, left: 10, bottom: 10, right: 10)
        static let emptyImageURL: String = "https://previews.123rf.com/images/siamimages/siamimages1504/siamimages150401064/39173277-%EC%82%AC%EC%A7%84-%EC%97%86%EC%9D%8C-%EC%95%84%EC%9D%B4%EC%BD%98-%EC%97%86%EC%9D%8C.jpg"

    }
    
    private enum Text {
        static let searchBarPlaceholder: String = "읽고싶은 책을 검색 해보세요. (2글자 이상)"
        static let navigationTitle: String = "책 검색"
        static let navigationSearchedTitle: String = "검색결과"
    }
    
}

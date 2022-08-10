//
//  BookDetailViewController.swift
//  BookFinder
//
//  Created by BH on 2022/08/10.
//

import UIKit
import WebKit

import SnapKit

final class BookDetailViewController: UIViewController {
    
    // MARK: - UIProperties
    
    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        return webView
    }()
    
    // MARK: - Properties
    
    var book: BookList
    
    init(book: BookList) {
        self.book = book
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    
    override func loadView() {
        self.view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
    }
    
}

// MARK: - BookDetailViewController Layout extension

extension BookDetailViewController {
    
    private func setupWebView() {
        if let url = URL(string: book.bookInfo.infoLink) {
            let urlRequest = URLRequest(url: url)
            webView.load(urlRequest)
        }
    }
    
}

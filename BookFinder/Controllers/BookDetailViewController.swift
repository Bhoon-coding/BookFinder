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
    
    private lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.hidesWhenStopped = true
        spinner.style = .large
        spinner.color = .systemBlue
        return spinner
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
        setupSpinner()
        setupConstraints()
    }
    
}

// MARK: - Views setup extension

extension BookDetailViewController {
    
    private func setupWebView() {
        webView.navigationDelegate = self
        
        if let url = URL(string: book.bookInfo.infoLink) {
            let urlRequest = URLRequest(url: url)
            webView.load(urlRequest)
        }
    }
    
    private func setupSpinner() {
        view.addSubview(spinner)
    }
    
}

// MARK: - Constraints extension

extension BookDetailViewController {
    
    private func setupConstraints() {
        setupConstraintsOfSpinner()
    }
    
    private func setupConstraintsOfSpinner() {
        spinner.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
}

// MARK: - WKNavigationDelegate extension

extension BookDetailViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        DispatchQueue.main.async {
            self.spinner.startAnimating()
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DispatchQueue.main.async {
            self.spinner.stopAnimating()
        }
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        DispatchQueue.main.async {
            self.spinner.stopAnimating()
        }
    }
    
}


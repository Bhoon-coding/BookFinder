//
//  SearchBookCollectionViewCell.swift
//  BookFinder
//
//  Created by BH on 2022/08/09.
//

import UIKit

import SnapKit

final class SearchBookCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UIProperties
    
    private lazy var bookImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = Style.cornerRadius
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private lazy var bookTitleLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byTruncatingTail
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.numberOfLines = Style.labelLineLimit
        return label
    }()
    
    private lazy var bottomLabelStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [authorLabel, publishedDataLabel])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        return stackView
    }()
    
    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        return label
    }()
    
    private lazy var publishedDataLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        return label
    }()
    
    // MARK: - Properties
    
    static let identifier = String(describing: SearchBookCollectionViewCell.self)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bookImageView.image = nil
        bookTitleLabel.text = ""
        authorLabel.text = ""
        publishedDataLabel.text = ""
    }
    
}

extension SearchBookCollectionViewCell {
    
    func setupCell(bookList: BookList) {
        let bookInfo: BookInfo = bookList.bookInfo
        var author: String
        
        if let authors = bookInfo.authors {
            if authors.count > 1 {
                author = "\(authors[0]) 외 \(authors.count - 1)명"
            } else {
                author = authors[0]
            }
        } else {
            author = Text.noAuthor
        }
        
        bookTitleLabel.text = bookInfo.title
        authorLabel.text = author
        publishedDataLabel.text = bookInfo.publishedDate
    }
    
    func setupImage(image: UIImage) {
        DispatchQueue.main.async {
            self.bookImageView.image = image
        }
    }
}

// MARK: - Cell Layout extension

extension SearchBookCollectionViewCell {
    
    private func setupView() {
        [bookImageView,
         bookTitleLabel,
         bottomLabelStackView].forEach {
            self.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        setupConstraintsOfBookImageView()
        setupConstraintsOfBookTitleLabel()
        setupConstraintsOfBottomLabelStackView()
    }
    
    private func setupConstraintsOfBookImageView() {
        bookImageView.snp.makeConstraints {
            $0.leading.top.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(self.frame.height * 0.3)
        }
    }
    
    private func setupConstraintsOfBookTitleLabel() {
        bookTitleLabel.snp.makeConstraints {
            $0.top.equalTo(bookImageView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
    }
    
    private func setupConstraintsOfBottomLabelStackView() {
        bottomLabelStackView.snp.makeConstraints {
            $0.top.equalTo(bookTitleLabel.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(self.frame.height * 0.1)
        }
    }
    
}

// MARK: - NameSpaces

extension SearchBookCollectionViewCell {
    
    private enum Style {
        static let labelLineLimit: Int = 2
        static let cornerRadius: CGFloat = 20
    }
    
    private enum Text {
        static let noAuthor: String = "작자 미상"
    }
}


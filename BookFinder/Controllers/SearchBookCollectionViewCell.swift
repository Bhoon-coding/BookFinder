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
        imageView.backgroundColor = .darkGray
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
        stackView.backgroundColor = .brown
        
        return stackView
    }()
    
    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var publishedDataLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    // MARK: - Properties
    
    static let identifier: String = "SearchBookCollectionViewCell"

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    func setupCell(book: BookList) {
        let bookInfo: BookInfo = book.bookInfo
        bookTitleLabel.text = bookInfo.title
    }
    
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
            $0.bottom.equalToSuperview().inset(frame.height / 3)
        }
    }
    
    private func setupConstraintsOfBookTitleLabel() {
        bookTitleLabel.snp.makeConstraints {
            $0.top.equalTo(bookImageView.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview()
        }
    }
    
    private func setupConstraintsOfBottomLabelStackView() {
        bottomLabelStackView.snp.makeConstraints {
            $0.top.equalTo(bookTitleLabel.snp.bottom).offset(8)
            $0.leading.trailing.bottom.equalToSuperview()
//            $0.height.equalTo(40)
        }
    }
    
}

// MARK: - NameSpaces

extension SearchBookCollectionViewCell {
    
    private enum Style {
        static let labelLineLimit: Int = 2
        static let cornerRadius: CGFloat = 20
    }
}


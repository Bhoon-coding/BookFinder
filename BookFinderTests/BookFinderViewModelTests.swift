//
//  BookFinderViewModelTests.swift
//  BookFinderViewModelTests
//
//  Created by BH on 2022/08/09.
//

import XCTest
@testable import BookFinder

class BookFinderViewModelTests: XCTestCase {
    
    var viewModel: SearchBookViewModel!

    override func setUpWithError() throws {
        try super.setUpWithError()
        viewModel = SearchBookViewModel()
    }

    override func tearDownWithError() throws {
        viewModel = nil
    }

    func test_fetchBookListCanGetData() throws {
        let searchText = "swift"
        let expectation = expectation(description: "bookList.count >= 10")
        
        viewModel.fetchBookList(with: searchText)
        viewModel.bookList.bind {
            if $0.count >= 10 {
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 3)
    }
    
    func test_fetchAnotherBookListCanGetData() throws {
        let searchedTitle = "iOS"
        let startIndex = 2
        let expectation = expectation(description: "bookList.count >= 10")
        
        viewModel.fetchAnotherBookList(searchedTitle: searchedTitle, startIndex: startIndex)
        viewModel.bookList.bind {
            if $0.count >= 10 {
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 3)
    }
    
    func test_fetchImageCanConvertToUIImage() throws {
        let urlString = "https://image.rocketpunch.com/company/4084/wanted_logo_1519203285.jpg?s=400x400&t=inside"
        let expectation = expectation(description: "String -> UIImage 변환하는지 확인")
        
        viewModel.fetchImage(bookImageURL: urlString) {
            print(self.viewModel.bookImage.value)
            if type(of: self.viewModel.bookImage.value) == UIImage.self {
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 3)
    }

}

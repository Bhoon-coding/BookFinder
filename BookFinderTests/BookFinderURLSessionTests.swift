//
//  BookFinderURLSessionTests.swift
//  BookFinderTests
//
//  Created by BH on 2022/08/11.
//

import XCTest

class BookFinderURLSessionTests: XCTestCase {
    
    var sut: URLSession!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = URLSession(configuration: .default)
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }

    func test_ValidAPICallGetHTTPSatusCode200() throws {
        let urlString = "https://www.googleapis.com/books/v1/volumes?key=AIzaSyBNDyZjwm54nksCpMh7TGVnj6yzYWfNNIU&q=swift"
        let url = URL(string: urlString)!
        let expectation = expectation(description: "Status code 200")
        var statusCode: Int?
        var responseError: Error?
        
        let dataTask = sut.dataTask(with: url) { _, response, error in
            statusCode = (response as? HTTPURLResponse)?.statusCode
            responseError = error
            expectation.fulfill()
        }
        dataTask.resume()
        wait(for: [expectation], timeout: 3)
        
        XCTAssertNil(responseError)
        XCTAssertEqual(statusCode, 200)
    }

}

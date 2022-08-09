//
//  ViewController.swift
//  BookFinder
//
//  Created by BH on 2022/08/09.
//

import UIKit

class ViewController: UIViewController {
    
    var bookList: [BookListResults] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("test")
        fetchBookList { result in
            switch result {
            case .success(let data):
                self.bookList.append(data)
                dump(self.bookList)
                print("성공")
            case .failure(let err):
                print("Error: \(err)")
            }
        }
        
    }
    
    func fetchBookList(
        completion: @escaping (Result<BookListResults, Error>) -> Void
    ) {
        
        let url = URL(string: "https://www.googleapis.com/books/v1/volumes?q=객체")
        
        guard let urlRequest = url else {
            print("유효하지 않은 url 입니다.")
            return
        }
        
        let session: URLSession = .shared
        
        let task = session.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                print("네트워크 에러:\(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                return
            }
            guard 200..<300 ~= httpResponse.statusCode else {
                print("statusCode Error: \(httpResponse.statusCode)")
                return
            }
            guard let data = data else {
                print("Empty Data")
                return
            }
            
            guard let decodedData = try? JSONDecoder().decode(BookListResults.self, from: data) else { return }
            
            dump(decodedData)
        
        }
        task.resume()
    }

}


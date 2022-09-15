//
//  BookImageAPIProvider.swift
//  BookFinder
//
//  Created by BH on 2022/08/09.
//

import Foundation
import UIKit.UIImage

protocol BookImageProviderType {
    
    func fetchImage(
        with urlString: String,
        completion: @escaping (Result<UIImage, NetworkError>) -> Void
    )
    
}
// APIKIt 스터디
struct BookImageProvider: BookImageProviderType {
    
    private let networkRequester: NetworkRequesterType
    private var imageCahe = NSCache<NSString, UIImage>()
    
    func fetchImage(
        with urlString: String,
        completion: @escaping (Result<UIImage, NetworkError>) -> Void
    ) {
        let cacheKey = NSString(string: urlString)
        if let cachedImage = imageCahe.object(forKey: cacheKey) {
            completion(.success(cachedImage))
        }
        networkRequester.request(to: urlString) { result in
            switch result {
                
            case .success(let data):
                guard let image = UIImage(data: data) else {
                    completion(.failure(.emptyData))
                    return
                }
                self.imageCahe.setObject(image, forKey: cacheKey)
                completion(.success(image))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
}

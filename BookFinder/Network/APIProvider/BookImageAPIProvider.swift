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
        completion: @escaping (Result<UIImage, Error>) -> Void
    )
    
}

class BookImageProvider: BookImageProviderType {
    
    private var networkRequester: NetworkRequesterType
    private var imageCahe = NSCache<NSString, UIImage>()
    
    init(networkRequester: NetworkRequesterType) {
        self.networkRequester = networkRequester
    }
    
    func fetchImage(
        with urlString: String,
        completion: @escaping (Result<UIImage, Error>) -> Void
    ) {
        let cacheKey = NSString(string: urlString)
        if let cachedImage = imageCahe.object(forKey: cacheKey) {
            completion(.success(cachedImage))
        }
        networkRequester.request(to: urlString) { result in
            switch result {
            case .success(let data):
                guard let image = UIImage(data: data) else {
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

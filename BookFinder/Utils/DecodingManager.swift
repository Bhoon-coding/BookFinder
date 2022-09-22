//
//  DecodingManager.swift
//  BookFinder
//
//  Created by BH on 2022/09/21.
//

import Foundation

enum DecodingError: LocalizedError {
    
    case decodingFail
    
    var errorDescription: String? {
        switch self {
        case .decodingFail:
            return "Decoding 실패"
        }
    }
}

struct DecodingManager {
    
    private let decoder = JSONDecoder()
    
    func decode<Model: Decodable>(
        _ data: Data,
        with model: Model.Type
    ) -> Result<Model, DecodingError> {
        guard let decodedData = try? decoder.decode(model, from: data) else {
            return .failure(DecodingError.decodingFail)
        }
        return .success(decodedData)
    }
}

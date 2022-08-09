//
//  Bundle + extension.swift
//  BookFinder
//
//  Created by BH on 2022/08/09.
//

import Foundation

extension Bundle {
    var apiKey: String {
        guard let file = self.path(forResource: "PhotoInfo", ofType: "plist") else { return "" }
        guard let resource = NSDictionary(contentsOfFile: file) else { return "" }
        guard let key = resource["API_KEY"] as? String else {
            fatalError("BookListInfo.plist에 API_KEY 설정을 해주세요.")
        }
        return key
    }
}

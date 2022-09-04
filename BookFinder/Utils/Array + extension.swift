//
//  Array + extension.swift
//  BookFinder
//
//  Created by BH on 2022/09/03.
//

import Foundation

extension Array {
    subscript (safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}

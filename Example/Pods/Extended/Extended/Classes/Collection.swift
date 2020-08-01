//
//  Collection.swift
//  Extended
//
//  Created by Skyler Smith on 2018-11-09.
//

import Foundation

extension Collection {
    /// Safely retrieve the element at `index`
    public func at(_ index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

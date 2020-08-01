//
//  Array.swift
//  Extended
//
//  Created by Skyler Smith on 2018-11-09.
//

import Foundation

extension Array {
    /// Safely retrive the element in the middle of the array
    public func middleElement(roundedUp: Bool) -> Element? {
        let middleIndex: Int
        if count % 2 == 0 {
            middleIndex = (count / 2) - (roundedUp ? 0 : 1)
        } else {
            middleIndex = (count - 1) / 2
        }
        return at(middleIndex)
    }
    
    /// Retrieve `numSamples` of evenly distributed samples from the array.
    public func sample(_ numSamples: Int) -> Array<Element> {
        guard numSamples < count else { return self }
        guard numSamples > 0 else { return [] }
        let increment = Float(count) / Float(numSamples)
        var array = Array<Element>()
        for i in 0..<numSamples {
            array.append(self[Int(ceil(Float(i) * increment))])
        }
        return array
    }
}

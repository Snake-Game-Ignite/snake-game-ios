//
//  Array+Utils.swift
//  snakegame
//
//  Created by David Southgate on 22/01/2024.
//

import Foundation

extension Array {
    
    /// Safe array access and modification. Returns nil or does nothing if index out of bounds.
    public subscript(at index: Int) -> Element? {
        get {
            guard index >= 0, index < endIndex else {
                return nil
            }
            return self[index]
        }
        mutating set(newValue) {
            guard let newValue,
                  index >= 0, index < endIndex else {
                return
            }
            self[index] = newValue
        }
    }
}

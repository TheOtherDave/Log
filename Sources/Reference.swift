//
//  Reference.swift
//  Log
//
//  Created by David Sweeris on 2/6/17.
//
//

import Foundation

/// Just a quick way to get reference semantics for any type. It's not public because it never gets exposed, plus I'm sure a lot of people already define their own `Box` type.
class Box<T> {
    var unbox: T!
    init?(_ value: T?) {
        self.unbox = value
        if value == nil {
            return nil
        }
    }
}

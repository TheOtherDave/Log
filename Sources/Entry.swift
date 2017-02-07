//
//  Entry.swift
//  Log
//
//  Created by David Sweeris on 2/6/17.
//
//

import Foundation

/// To support the tagging feature, `Log` stores its entries a bit like a database. This is a "flattened" representation of a log entry containing everything you could ever want to know about a given entry
public struct Entry<Key,Value> {
    public let key: Key
    public let tags: [String]
    public let entry: Value
    
    init(key: Key, tags: [String], value: Value) {
        self.key = key
        self.tags = tags
        self.entry = value
    }
    init(key: Key, tags: [Tag], value: Value) {
        self.key = key
        self.tags = tags.map {$0.description}
        self.entry = value
    }
}
//TODO: Make this conformance condition on `Key` and `Value` conforming
extension Entry : CustomStringConvertible {
    public var description: String {
        switch tags.count {
        case 0: return "\(key)\nTags: <none>)\nEntry:\n\(entry)"
        case _: return "\(key)\nTags: \(tags)\nEntry:\n\(entry)"
        }
    }
}

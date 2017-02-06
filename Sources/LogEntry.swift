//
//  LogEntry.swift
//  Log
//
//  Created by David Sweeris on 2/4/17.
//
//

import Foundation

public struct LogEntry<Key: Hashable & CustomStringConvertible> : CustomStringConvertible {
    public let key: Key
    public let tags: [String]
    public let description: String
    
    init(key: Key, tags: [String], value: String) {
        self.key = key
        self.tags = tags
        self.description = value
    }
    init(key: Key, tags: [Tag], value: String) {
        self.key = key
        self.tags = tags.map {$0.description}
        self.description = value
    }
}

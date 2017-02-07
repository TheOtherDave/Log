//
//  Entry.swift
//  Log
//
//  Created by David Sweeris on 2/6/17.
//
//

import Foundation

/// To support the tagging feature, `Log` stores its entries a bit like a database. This is a "flattened" representation of a log entry containing everything you could ever want to know about a given entry
public struct Entry<Value: Equatable&CustomStringConvertible> : Hashable {
    public var hashValue: Int {
        return key.hashValue ^ "\(entry)".hashValue
    }
    public static func == (lhs: Entry<Value>, rhs: Entry<Value>) -> Bool {
        return lhs.key == rhs.key && lhs.entry == rhs.entry
    }
    internal weak var log: Log<Value>?
    public let key: Date
    private var tagCache: Set<String>?
    public var tags: Set<String> {
        get { return log?.tagsForKey[key] ?? tagCache ?? [] }
        set {
            tagCache = newValue
            log?.tagsForKey[key] = newValue
        }
    }
    private let _entry: Value?
    public var entry: Value { return _entry! }
    
    internal init(key: Date, tags: Set<String>, entry: Value, log: Log<Value>) {
        self.key = key
        self.tagCache = tags
        self._entry = entry
        self.log = log
    }
//    internal init(key: Date, tags: Set<Tag>, entry: Value, log: Log<Value>) {
//        self.key = key
//        self._tags = Set(tags.map {$0.description})
//        self._entry = entry
//        self.log = log
//    }
    internal init?(key: Date, tags: Set<String>?, entry: Value?, log: Log<Value>) {
        if let entry = entry {
            self.key = key
            self.tagCache = Set(tags?.map {$0.description} ?? [])
            self._entry = entry
            self.log = log
        } else {
            self.key = key
            self.tagCache = Set(tags?.map {$0.description} ?? [])
            self._entry = entry
            self.log = log
            return nil
        }
    }
    
}
//TODO: Make this conformance condition on `Date` and `Value` conforming
extension Entry : CustomStringConvertible {
    public var description: String {
        switch tags.count {
//        case 0: return "\(key)\nTags: <none>)\nEntry:\n\(entry)"
        case 0: return "\(key): \(entry)"
        case _: return "\(key)\nTags: \(tags)\nEntry:\n\(entry)"
        }
    }
}

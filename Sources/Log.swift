import Foundation

/// A "medium weight" class for logging things. It's a bit more structured than a `Dictionary`, but not as powerful as a full database (and likely less efficient). It's a wrapper for [Date : Value], with some added functionality for tagging entries.
public class Log<Value: Equatable> : ExpressibleByDictionaryLiteral, Collection {
    public typealias Index = Date
    
    // TODO: Actually implement this
    public static func == (lhs: Log, rhs: Log) -> Bool {
        return lhs === rhs
//        guard lhs.logbook.count == rhs.logbook.count else { return false }
//        guard lhs.tagsForKey.count == rhs.logbook.count else { return false }
//        guard lhs.logbook.count == rhs.logbook.count else { return false }
//        return
    }
    
    // MARK: - Book-Keeping stuff
    fileprivate private(set) var _keys: [Date] = []
    fileprivate private(set) var _tags: [String] = []
    
    // MARK: - Private Storage
    private var tagsForKey: [Date : Set<Tag>] = [:]
    private var keysForTag: [Tag : Set<Date>] = [:]
    private var logbook: [Date : Value] = [:]
    private var indexForFirstEntry: Date?
    private var indexForLastEntry: Date?

    // MARK: - Public Properties
    public let creationDate = Date()
    
    // MARK: - Collection Conformance
    public var startIndex: Index { return _keys[_keys.startIndex] }
    public var endIndex: Index { return _keys[_keys.endIndex] }
    public var count: Int { return _keys.count }
    public func index(after i: Date) -> Date {
        return _keys[_keys.index(of: i)! + 1]
    }
    
    // MARK: - inits
    public init() {}
    public required init(dictionaryLiteral elements: (Date, Value)...) {
        for el in elements {
            logbook[el.0] = el.1
        }
    }
    
    // MARK: - Public Accessors
    /// We specifically do _not_ provide a setter for keys because Logs are intended to be "update-only" types.
    public subscript(_ key: Date) -> Value? { return logbook[key] }

    subscript(tagsFor key: Date) -> Set<Tag>? {
        get { return tagsForKey[key] }
        set { tagsForKey[key] = newValue }
    }
    subscript(keysFor tag: Tag) -> Set<Date>? {
        get { return keysForTag[tag] }
        set { keysForTag[tag] = newValue }
    }
    subscript(keysFor tag: Tag?) -> Set<Date> { return tag == nil ? [] : keysForTag[tag!] ?? [] }
    subscript(tag: String) -> [Entry<Date, Value>] {
        return (keysForTag[Tag(tag)] ?? [])
            .map { Entry(key: $0, tags: Array(tagsForKey[$0] ?? []), value: logbook[$0]!) }
    }
    subscript() -> Value? {
        get {return nil}
        set {if let nv = newValue { logbook[Date()] = nv } }
    }
    subscript() -> (tags: [String], entry: Value)? {
        get {return nil}
        set {
            if let nv = newValue {
                let key = Date()
                logbook[key] = nv.entry
                tagsForKey[key]?.formUnion(nv.tags.map {Tag($0)})
            }
        }
    }
    func tag(keys: Date..., with tagStr: String) {
        let tag = Tag(tagStr)
        keysForTag[tag]?.formUnion(keys)
    }
}

// MARK: - Hashable
extension Log : Hashable {
    public var hashValue: Int { return creationDate.hashValue ^ _keys.count }
    
}

// MARK: - Expressible
extension Log  {
    /// Returns an iterator over the elements of this sequence.
}

// TODO: Make this conformance condition on `Entry` conforming
extension Log : CustomStringConvertible {
    public var description: String {
        return ""
    }
}

// MARK: - Convenince Accessor Methods
// They're in an extension rather than the base declaration to ensure that they go through an existing public accessor and don't mess with the storage directly
extension Log {
    public subscript(_ key: Date?) -> Value? { return key == nil ? nil : self[key!] }
    public subscript(_ keys: [Date]) -> [Value] { return keys.flatMap { self[$0] } }
    public subscript(_ keys: Date...) -> [Value] { return self[keys] }
    public subscript(_ keys: [Date?]) -> [Value] { return keys.flatMap { self[$0] } }
    public subscript(_ keys: Date?...) -> [Value] { return self[keys] }
    
    public subscript(tagsFor key: Date?) -> Set<Tag>? {
        get { return key == nil ? nil : self[tagsFor: key!] }
        set { if let key = key { self[tagsFor: key] = newValue } }
    }
}

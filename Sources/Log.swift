import Foundation

/// A "medium weight" class for logging things. It's a bit more structured than a `Dictionary`, but not as powerful as a full database (and likely less efficient). It's a wrapper for [Date : Value], with some added functionality for tagging entries.
public class Log<Value: Equatable&CustomStringConvertible> : ExpressibleByDictionaryLiteral {
    
    // FIXME: Actually implement this
    public static func == (lhs: Log, rhs: Log) -> Bool { return lhs === rhs }
    
    // MARK: - Book-Keeping stuff
    fileprivate private(set) var _keys: Set<Date> = []
    fileprivate private(set) var _tags: Set<String> = []
     private(set) var _lastDate: Date? = nil
    
    // MARK: - Private Storage
    fileprivate var logbook: [Date : Value] = [:]
    private var indexForFirstEntry: Date?
    private var indexForLastEntry: Date?

    // MARK: - Public Properties
    public var count: Int { return logbook.count }
    public var tagsForKey: [Date : Set<String>] = [:]
    public var keysForTag: [String : Set<Date>] = [:]
    public var last: Entry<Value>? {
        return _lastDate == nil ? nil : self[_lastDate!]
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
    public subscript(_ key: Date) -> Entry<Value>? {
        return Entry(key: key, tags: tagsForKey[key], entry: logbook[key], log: self)
    }
    public subscript(_ tag: String) -> Set<Entry<Value>> {
        return Set((keysForTag[tag] ?? []).flatMap {self[$0]})
    }

    public subscript(tagsFor key: Date) -> Set<String> {
        get { return tagsForKey[key] ?? [] }
        set { tagsForKey[key] = newValue }
    }
    
    // MARK: - Adding new entries/tags
    public subscript() -> Value {
        get {fatalError()}
        set {
            let key = Date()
            logbook[key] = newValue
            _keys.insert(key)
            _lastDate = key
        }
    }
    public subscript() -> (entry: Value, tag: String) {
        get {fatalError()}
        set { self[] = (entry: newValue.entry, tags: [newValue.tag]) }
    }
    public subscript() -> (entry: Value, tags: [String]) {
        get {fatalError()}
        set {
            let key = Date()
            logbook[key] = newValue.entry
            var oldTags = (tagsForKey[key] ?? [])
            newValue.tags.forEach { oldTags.insert($0) }
            tagsForKey[key] = oldTags
            _keys.insert(key)
            _lastDate = key
        }
    }
    public func newEntry(_ entry: Value, withTags tags: String...) {
        newEntry(entry, withTags: tags)
    }
    public func newEntry(_ entry: Value, withTags tags: [String]) {
        let key = Date()
        logbook[key] = entry
        _keys.insert(key)
        _lastDate = key
        self[tagsFor: key].formUnion(tags.map {$0})
    }
    public func tag(_ message: String...) {
        tag(message)
    }
    public func tag(_ message: [String]) {
        guard let _lastDate = _lastDate else { return }
        tag(key: _lastDate, message)
    }
    public func tag(key: Date, _ message: String...) {
        tag(key: key, message)
    }
    public func tag(key: Date, _ message: [String]) {
        tagsForKey[key] = (tagsForKey[key] ?? []).union(message)
    }
    func tag(_ keys: Date..., with tagStr: String) {
        tag(keys, with: tagStr)
    }
    func tag(_ keys: [Date], with tag: String) {
        keysForTag[tag]?.formUnion(keys)
        for key in keys {
            self[tagsFor: key].formUnion([tag])
        }
    }
    public func update(tags: String..., forKey: Date) {
        
    }
    public func update(tags: Set<String>, forKey: Date) {
        
    }
    
//    func tag(_ key: Date, with tagStr: String...) {
//        tag(key, with: tagStr)
//    }
//    func tag(_ key: Date, with tagStr: [String]) {
//        let tag = Tag(tagStr)
//        tags
//    }
}

// MARK: - Convenince Accessor Methods
// They're in an extension rather than the base declaration to ensure that they go through an existing public accessor and don't mess with the storage directly
extension Log {
    public subscript(_ keys: [Date]) -> [Value] { return keys.flatMap { self[$0] } }
    public subscript(_ keys: Date...) -> [Value] { return self[keys] }
    public subscript(checking keys: [Date?]) -> [Value] { return keys.flatMap { self[checking: $0] } }
    public subscript(checking keys: Date?...) -> [Value] { return self[checking: keys] }
    
    public subscript(checking_tagsFor key: Date?) -> Set<String>? {
        get { return key == nil ? nil : self[tagsFor: key!] }
        set { if let key = key, let nv = newValue { self[tagsFor: key] = nv } }
    }
}

// MARK: - Hashable Conformance
extension Log : Hashable {
    public var hashValue: Int { return _keys.reduce(0) {$0.hashValue ^ $1.hashValue} }
}


// MARK: - CustomStringConvertible Conformance
// TODO: Make this conformance condition on `Entry` conforming
extension Log : CustomStringConvertible {
    public var description: String {
        return self
            .map { $0.description }
            .joined(separator: "\n")
    }
}

// MARK: - Sequence Conformance
extension Log : Sequence {
    public typealias Index = Date
    public typealias Iterator = LogIterator<Value>
    
    public func makeIterator() -> Iterator {
        return Iterator(self)
    }
}

public struct LogIterator<Value: Equatable&CustomStringConvertible> : IteratorProtocol {
    public typealias Element = Array<Entry<Value>>.Iterator.Element
    
    private var log: Log<Value>
    private lazy var iterator: SetIterator<Date> = {
        return self.log._keys.makeIterator()
    }()
    init(_ log: Log<Value>) {
        self.log = log
    }
    public mutating func next() -> Entry<Value>? {
        let nxt = iterator.next()
        let entry = nxt == nil ? nil : log[nxt!]
        return entry
    }
}

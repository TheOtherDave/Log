import Foundation

/// A "medium weight" class for logging things. It's a bit more structured than a
/// Dictionary, but not as powerful as a full database (and likely less efficient)
public typealias KeyType = Hashable & CustomStringConvertible
public class Log<Key: KeyType> {
    private var tagsForKey: [Key : Set<Tag>] = [:]
    private var keysForTag: [Tag : Set<Key>] = [:]
    private var logbook: [Key : String] = [:]
    public init() {}
    
    subscript(_ key: Key) -> String? {
        return logbook[key]
    }
    subscript(_ keys: [Key]) -> [String] {
        return keys.flatMap { logbook[$0] }
    }
    
    subscript(tag: String) -> [LogEntry<Key>] {
        return (keysForTag[Tag(tag)] ?? [])
            .map { LogEntry(key: $0, tags: Array(tagsForKey[$0] ?? []), value: logbook[$0] ?? "")}
    }
    func tag(keys: [Key], with tagStr: String) {
        let tag = Tag(tagStr)
        keysForTag[tag]?.formUnion(keys)
    }
    func tag(keys: Key..., with tag: String) {
        self.tag(keys: keys, with: tag)
    }
    func tag(key: Key, with tag: String) {
        self.tag(keys: [key], with: tag)
    }
}

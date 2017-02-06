//
//  Tag.swift
//  Log
//
//  Created by David Sweeris on 2/4/17.
//
//

import Foundation

/// Just a class wrapper around String, so that the Log objects don't get so big
final public class Tag : CustomStringConvertible, ExpressibleByStringLiteral, Hashable {
    public typealias StringLiteralType = String.StringLiteralType
    public typealias UnicodeScalarLiteralType = String.UnicodeScalarLiteralType
    public typealias ExtendedGraphemeClusterLiteralType = String.ExtendedGraphemeClusterLiteralType
    
    public static func == (lhs: Tag, rhs: Tag) -> Bool {
        return lhs.description == rhs.description
    }
    
    public let description: String
    public init(_ value: String) {
        description = value
    }
    public init(stringLiteral value: StringLiteralType) {
        description = value
    }
    public init(unicodeScalarLiteral value: UnicodeScalarLiteralType) {
        description = value
    }
    public init(extendedGraphemeClusterLiteral value: ExtendedGraphemeClusterLiteralType) {
        description = value
    }
    public var hashValue: Int { return description.hashValue }
}

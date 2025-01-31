//
//  Token.swift
//  SwiftyMarkdown
//
//  Created by Simon Fairbairn on 04/02/2020.
//

import Foundation

// Tag definition
public protocol CharacterStyling {
    func isEqualTo(_ other: CharacterStyling) -> Bool
}

// Token definition
public enum TokenType {
    case repeatingTag
    case openTag
    case intermediateTag
    case closeTag
    case string
    case escape
    case replacement
}

public struct Token {
    public let id = UUID().uuidString
    public let type: TokenType
    public let inputString: String
    public var metadataStrings: [String] = []
    public internal(set) var group: Int = 0
    public internal(set) var characterStyles: [CharacterStyling] = []
    public internal(set) var count: Int = 0
    public internal(set) var shouldSkip: Bool = false
    public internal(set) var tokenIndex: Int = -1
    public internal(set) var isProcessed: Bool = false
    public internal(set) var isMetadata: Bool = false
    public var children: [Token] = []

    public var outputString: String {
        switch type {
        case .repeatingTag:
            if count <= 0 {
                return ""
            } else {
                let range = inputString.startIndex ..< inputString.index(inputString.startIndex, offsetBy: count)
                return String(inputString[range])
            }
        case .openTag,
             .closeTag,
             .intermediateTag:
            return (isProcessed || isMetadata) ? "" : inputString
        case .escape,
             .string:
            return (isProcessed || isMetadata) ? "" : inputString
        case .replacement:
            return inputString
        }
    }

    public init(type: TokenType, inputString: String, characterStyles: [CharacterStyling] = []) {
        self.type = type
        self.inputString = inputString
        self.characterStyles = characterStyles
        if type == .repeatingTag {
            count = inputString.count
        }
    }

    func newToken(fromSubstring string: String, isReplacement: Bool) -> Token {
        var newToken = Token(type: isReplacement ? .replacement : .string, inputString: string, characterStyles: characterStyles)
        newToken.metadataStrings = metadataStrings
        newToken.isMetadata = isMetadata
        newToken.isProcessed = isProcessed
        return newToken
    }
}

extension Sequence where Iterator.Element == Token {
    var oslogDisplay: String {
        "[\"\(map { ($0.outputString.isEmpty) ? "\($0.type): \($0.inputString)" : $0.outputString }.joined(separator: "\", \""))\"]"
    }
}

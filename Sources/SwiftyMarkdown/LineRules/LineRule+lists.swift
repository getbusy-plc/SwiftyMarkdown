import Foundation

public extension LineRule {
    static var listIndentationLevels = 10

    static func listRules() -> [LineRule] {
        var rules = [LineRule]()
        for level in (1...listIndentationLevels).reversed() {
            rules.append(unorderedList(bullet: "-", indent: "\t", level: level))
            rules.append(unorderedList(bullet: "-", indent: "  ", level: level))
        }
        for level in (1...listIndentationLevels).reversed() {
            rules.append(unorderedList(bullet: "*", indent: "\t", level: level))
            rules.append(unorderedList(bullet: "*", indent: "  ", level: level))
        }
        for level in (1...listIndentationLevels).reversed() {
            rules.append(unorderedList(bullet: "+", indent: "\t", level: level))
            rules.append(unorderedList(bullet: "+", indent: "  ", level: level))
        }
        for level in (1...listIndentationLevels).reversed() {
            rules.append(orderedList(indent: "\t", level: level))
            rules.append(orderedList(indent: "  ", level: level))
        }

        rules.append(orderedList())
        rules.append(unorderedList(bullet: "-"))
        rules.append(unorderedList(bullet: "*"))
        rules.append(unorderedList(bullet: "+"))
        return rules
    }

    static func orderedList() -> LineRule {
        LineRule(
            token: "1. ",
            type : MarkdownLineStyle.orderedList(level: 0),
            removeFrom: .leading
        )
    }

    static func orderedList(
        indent: String,
        level: Int
    ) -> LineRule {
        let indentToken = String(repeating: indent, count: level)
        return LineRule(
            token: "\(indentToken)1. ",
            type : MarkdownLineStyle.orderedList(level: level),
            removeFrom: .leading,
            shouldTrim: false
        )
    }

    static func unorderedList(bullet: String) -> LineRule {
        LineRule(
            token: "\(bullet) ",
            type : MarkdownLineStyle.unorderedList(level: 0),
            removeFrom: .leading
        )
    }

    static func unorderedList(
        bullet: String,
        indent: String,
        level: Int
    ) -> LineRule {
        let indentToken = String(repeating: indent, count: level)
        return LineRule(
            token: "\(indentToken)\(bullet) ",
            type : MarkdownLineStyle.unorderedList(level: level),
            removeFrom: .leading,
            shouldTrim: false
        )
    }
}

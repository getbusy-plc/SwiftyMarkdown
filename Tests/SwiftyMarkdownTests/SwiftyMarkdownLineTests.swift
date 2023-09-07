//
//  SwiftyMarkdownLineTests.swift
//  SwiftyMarkdownTests
//
//  Created by Simon Fairbairn on 05/03/2016.
//  Copyright © 2016 Voyage Travel Apps. All rights reserved.
//

@testable import SwiftyMarkdown
import XCTest

class SwiftyMarkdownTests: XCTestCase {
    func testThatOctothorpeHeadersAreHandledCorrectly() {
        let heading1 = StringTest(input: "# Heading 1", expectedOutput: "Heading 1")
        var smd = SwiftyMarkdown(string: heading1.input)
        XCTAssertEqual(smd.attributedString().string, heading1.expectedOutput)

        let heading2 = StringTest(input: "## Heading 2", expectedOutput: "Heading 2")
        smd = SwiftyMarkdown(string: heading2.input)
        XCTAssertEqual(smd.attributedString().string, heading2.expectedOutput)

        let heading3 = StringTest(input: "### #Heading #3", expectedOutput: "#Heading #3")
        smd = SwiftyMarkdown(string: heading3.input)
        XCTAssertEqual(smd.attributedString().string, heading3.expectedOutput)

        let heading4 = StringTest(input: "  #### #Heading 4 ####", expectedOutput: "#Heading 4")
        smd = SwiftyMarkdown(string: heading4.input)
        XCTAssertEqual(smd.attributedString().string, heading4.expectedOutput)

        let heading5 = StringTest(input: " ##### Heading 5 ####   ", expectedOutput: "Heading 5 ####")
        smd = SwiftyMarkdown(string: heading5.input)
        XCTAssertEqual(smd.attributedString().string, heading5.expectedOutput)

        let heading6 = StringTest(input: " ##### Heading 5 #### More ", expectedOutput: "Heading 5 #### More")
        smd = SwiftyMarkdown(string: heading6.input)
        XCTAssertEqual(smd.attributedString().string, heading6.expectedOutput)

        let heading7 = StringTest(input: "# **Bold Header 1** ", expectedOutput: "Bold Header 1")
        smd = SwiftyMarkdown(string: heading7.input)
        XCTAssertEqual(smd.attributedString().string, heading7.expectedOutput)

        let heading8 = StringTest(input: "## Header 2 _With Italics_", expectedOutput: "Header 2 With Italics")
        smd = SwiftyMarkdown(string: heading8.input)
        XCTAssertEqual(smd.attributedString().string, heading8.expectedOutput)

        let heading9 = StringTest(input: "    # Heading 1", expectedOutput: "# Heading 1")
        smd = SwiftyMarkdown(string: heading9.input)
        XCTAssertEqual(smd.attributedString().string, heading9.expectedOutput)

        let allHeaders = [heading1, heading2, heading3, heading4, heading5, heading6, heading7, heading8, heading9]
        smd = SwiftyMarkdown(string: allHeaders.map(\.input).joined(separator: "\n"))
        XCTAssertEqual(smd.attributedString().string, allHeaders.map(\.expectedOutput).joined(separator: "\n"))

        let headerString = StringTest(
            input: "# Header 1\n## Header 2 ##\n### Header 3 ### \n#### Header 4#### \n##### Header 5\n###### Header 6",
            expectedOutput: "Header 1\nHeader 2\nHeader 3\nHeader 4\nHeader 5\nHeader 6"
        )
        smd = SwiftyMarkdown(string: headerString.input)
        XCTAssertEqual(smd.attributedString().string, headerString.expectedOutput)

        let headerStringWithBold = StringTest(input: "# **Bold Header 1**", expectedOutput: "Bold Header 1")
        smd = SwiftyMarkdown(string: headerStringWithBold.input)
        XCTAssertEqual(smd.attributedString().string, headerStringWithBold.expectedOutput)

        let headerStringWithItalic = StringTest(input: "## Header 2 _With Italics_", expectedOutput: "Header 2 With Italics")
        smd = SwiftyMarkdown(string: headerStringWithItalic.input)
        XCTAssertEqual(smd.attributedString().string, headerStringWithItalic.expectedOutput)
    }

    func testThatUndelinedHeadersAreHandledCorrectly() {
        let h1String = StringTest(input: "Header 1\n===\nSome following text", expectedOutput: "Header 1\nSome following text")
        var md = SwiftyMarkdown(string: h1String.input)
        XCTAssertEqual(md.attributedString().string, h1String.expectedOutput)

        let h2String = StringTest(input: "Header 2\n---\nSome following text", expectedOutput: "Header 2\nSome following text")
        md = SwiftyMarkdown(string: h2String.input)
        XCTAssertEqual(md.attributedString().string, h2String.expectedOutput)

        let h1StringWithBold = StringTest(
            input: "Header 1 **With Bold**\n===\nSome following text",
            expectedOutput: "Header 1 With Bold\nSome following text"
        )
        md = SwiftyMarkdown(string: h1StringWithBold.input)
        XCTAssertEqual(md.attributedString().string, h1StringWithBold.expectedOutput)

        let h2StringWithItalic = StringTest(
            input: "Header 2 _With Italic_\n---\nSome following text",
            expectedOutput: "Header 2 With Italic\nSome following text"
        )
        md = SwiftyMarkdown(string: h2StringWithItalic.input)
        XCTAssertEqual(md.attributedString().string, h2StringWithItalic.expectedOutput)

        let h2StringWithCode = StringTest(
            input: "Header 2 `With Code`\n---\nSome following text",
            expectedOutput: "Header 2 With Code\nSome following text"
        )
        md = SwiftyMarkdown(string: h2StringWithCode.input)
        XCTAssertEqual(md.attributedString().string, h2StringWithCode.expectedOutput)
    }

    func test_unorderedList_dashBullets_tabIndents() {
        let test = StringTest(
            input: "An Unordered List:\n"
                + "- Item 1\n"
                + "\t- Indented\n"
                + "\t\t- Indented again\n"
                + "- Item 2",
            expectedOutput: "An Unordered List:\n"
                + "-  Item 1\n"
                + "   *  Indented\n"
                + "      -  Indented again\n"
                + "-  Item 2"
        )

        let markdown = SwiftyMarkdown(string: test.input)
        markdown.bullet = "-"
        markdown.bulletAlt = "*"

        XCTAssertEqual(
            markdown.attributedString().string,
            test.expectedOutput
        )
    }

    func test_unorderedList_dashBullets_spaceIndents() {
        let test = StringTest(
            input: "An Unordered List:\n"
                + "- Item 1\n"
                + "  - Indented\n"
                + "    - Indented again\n"
                + "- Item 2",
            expectedOutput: "An Unordered List:\n"
                + "-  Item 1\n"
                + "   *  Indented\n"
                + "      -  Indented again\n"
                + "-  Item 2"
        )

        let markdown = SwiftyMarkdown(string: test.input)
        markdown.bullet = "-"
        markdown.bulletAlt = "*"

        XCTAssertEqual(
            markdown.attributedString().string,
            test.expectedOutput
        )
    }

    func test_unorderedList_starBullets_tabIndents() {
        let test = StringTest(
            input: "An Unordered List:\n"
                + "* Item 1\n"
                + "\t* Indented\n"
                + "\t\t* Indented again\n"
                + "* Item 2",
            expectedOutput: "An Unordered List:\n"
                + "-  Item 1\n"
                + "   *  Indented\n"
                + "      -  Indented again\n"
                + "-  Item 2"
        )

        let markdown = SwiftyMarkdown(string: test.input)
        markdown.bullet = "-"
        markdown.bulletAlt = "*"

        XCTAssertEqual(
            markdown.attributedString().string,
            test.expectedOutput
        )
    }

    func test_unorderedList_starBullets_spaceIndents() {
        let test = StringTest(
            input: "An Unordered List:\n"
                + "* Item 1\n"
                + "  * Indented\n"
                + "    * Indented again\n"
                + "* Item 2",
            expectedOutput: "An Unordered List:\n"
                + "-  Item 1\n"
                + "   *  Indented\n"
                + "      -  Indented again\n"
                + "-  Item 2"
        )

        let markdown = SwiftyMarkdown(string: test.input)
        markdown.bullet = "-"
        markdown.bulletAlt = "*"

        XCTAssertEqual(
            markdown.attributedString().string,
            test.expectedOutput
        )
    }

    func test_unorderedList_plusBullets_tabIndents() {
        let test = StringTest(
            input: "An Unordered List:\n"
                + "+ Item 1\n"
                + "\t+ Indented\n"
                + "\t\t+ Indented again\n"
                + "+ Item 2",
            expectedOutput: "An Unordered List:\n"
                + "-  Item 1\n"
                + "   *  Indented\n"
                + "      -  Indented again\n"
                + "-  Item 2"
        )

        let markdown = SwiftyMarkdown(string: test.input)
        markdown.bullet = "-"
        markdown.bulletAlt = "*"

        XCTAssertEqual(
            markdown.attributedString().string,
            test.expectedOutput
        )
    }

    func test_unorderedList_plusBullets_spaceIndents() {
        let test = StringTest(
            input: "An Unordered List:\n"
                + "+ Item 1\n"
                + "  + Indented\n"
                + "    + Indented again\n"
                + "+ Item 2",
            expectedOutput: "An Unordered List:\n"
                + "-  Item 1\n"
                + "   *  Indented\n"
                + "      -  Indented again\n"
                + "-  Item 2"
        )

        let markdown = SwiftyMarkdown(string: test.input)
        markdown.bullet = "-"
        markdown.bulletAlt = "*"

        XCTAssertEqual(
            markdown.attributedString().string,
            test.expectedOutput
        )
    }

    func test_unorderedList_maxIndent() {
        let test = StringTest(
            input: "An Unordered List:\n"
                + "- Item 1\n"
                + "\t- 1\n"
                + "\t\t- 2\n"
                + "\t\t\t- 3\n"
                + "\t\t\t\t- 4\n"
                + "\t\t\t\t\t- 5\n"
                + "\t\t\t\t\t\t- 6\n"
                + "\t\t\t\t\t\t\t- 7\n"
                + "\t\t\t\t\t\t\t\t- 8\n"
                + "\t\t\t\t\t\t\t\t\t- 9\n"
                + "\t\t\t\t\t\t\t\t\t\t- 10\n"
                + "- Item 2",
            expectedOutput: "An Unordered List:\n"
                + "-  Item 1\n"
                + "   *  1\n"
                + "      -  2\n"
                + "         *  3\n"
                + "            -  4\n"
                + "               *  5\n"
                + "                  -  6\n"
                + "                     *  7\n"
                + "                        -  8\n"
                + "                           *  9\n"
                + "                              -  10\n"
                + "-  Item 2"
        )

        let markdown = SwiftyMarkdown(string: test.input)
        markdown.bullet = "-"
        markdown.bulletAlt = "*"

        XCTAssertEqual(
            markdown.attributedString().string,
            test.expectedOutput
        )
    }

    func test_orderedList_tabIndents() {
        let test = StringTest(
            input: "An Ordered List:\n"
                + "1. Item 1\n"
                + "\t1. Indented\n"
                + "\t\t1. Indented again\n"
                + "1. Item 2",
            expectedOutput: "An Ordered List:\n"
                + "1.  Item 1\n"
                + "   1.  Indented\n"
                + "      1.  Indented again\n"
                + "2.  Item 2"
        )

        let markdown = SwiftyMarkdown(string: test.input)

        XCTAssertEqual(
            markdown.attributedString().string,
            test.expectedOutput
        )
    }

    func test_orderedList_spaceIndents() {
        let test = StringTest(
            input: "An Ordered List:\n"
                + "1. Item 1\n"
                + "  1. Indented\n"
                + "    1. Indented again\n"
                + "1. Item 2",
            expectedOutput: "An Ordered List:\n"
                + "1.  Item 1\n"
                + "   1.  Indented\n"
                + "      1.  Indented again\n"
                + "2.  Item 2"
        )

        let markdown = SwiftyMarkdown(string: test.input)

        XCTAssertEqual(
            markdown.attributedString().string,
            test.expectedOutput
        )
    }

    func test_orderedList_indentation() {
        let test = StringTest(
            input: "A long ordered list:\n"
                + "1. Item 1\n"
                + "1. Item 2\n"
                + "  1. First Indent 1\n"
                + "  1. First Indent 2\n"
                + "    1. Second Intent 1\n"
                + "    1. Second Intent 2\n"
                + "  1. First Indent 3\n"
                + "    1. Second Intent 3\n"
                + "1. Item 3",
            expectedOutput: "A long ordered list:\n"
                + "1.  Item 1\n"
                + "2.  Item 2\n"
                + "   1.  First Indent 1\n"
                + "   2.  First Indent 2\n"
                + "      1.  Second Intent 1\n"
                + "      2.  Second Intent 2\n"
                + "   3.  First Indent 3\n"
                + "      1.  Second Intent 3\n"
                + "3.  Item 3"
        )

        let markdown = SwiftyMarkdown(string: test.input)

        XCTAssertEqual(
            markdown.attributedString().string,
            test.expectedOutput
        )
    }

    func test_orderedList_maxIndent() {
        let test = StringTest(
            input: "An Ordered List:\n"
                + "1. Item 1\n"
                + "\t1. 1\n"
                + "\t\t1. 2\n"
                + "\t\t\t1. 3\n"
                + "\t\t\t\t1. 4\n"
                + "\t\t\t\t\t1. 5\n"
                + "\t\t\t\t\t\t1. 6\n"
                + "\t\t\t\t\t\t\t1. 7\n"
                + "\t\t\t\t\t\t\t\t1. 8\n"
                + "\t\t\t\t\t\t\t\t\t1. 9\n"
                + "\t\t\t\t\t\t\t\t\t\t1. 10\n"
                + "1. Item 2",
            expectedOutput: "An Ordered List:\n"
                + "1.  Item 1\n"
                + "   1.  1\n"
                + "      1.  2\n"
                + "         1.  3\n"
                + "            1.  4\n"
                + "               1.  5\n"
                + "                  1.  6\n"
                + "                     1.  7\n"
                + "                        1.  8\n"
                + "                           1.  9\n"
                + "                              1.  10\n"
                + "2.  Item 2"
        )

        let markdown = SwiftyMarkdown(string: test.input)

        XCTAssertEqual(
            markdown.attributedString().string,
            test.expectedOutput
        )
    }

    func test_orderedList_resetCounts() {
        let test = StringTest(
            input: "An Ordered List:\n"
                + "1. Item 1\n"
                + "\t1. A\n"
                + "\t\t1. X\n"
                + "\t\t\t1. 1\n"
                + "\t\t\t1. 2\n"
                + "\t\t\t1. 3\n"
                + "\t\t1. Y\n"
                + "\t1. B\n"
                + "\t\t1. X\n"
                + "1. Item 2\n"
                + "\t1. A\n"
                + "\t1. B\n"
                + "1. Item 3",
            expectedOutput: "An Ordered List:\n"
                + "1.  Item 1\n"
                + "   1.  A\n"
                + "      1.  X\n"
                + "         1.  1\n"
                + "         2.  2\n"
                + "         3.  3\n"
                + "      2.  Y\n"
                + "   2.  B\n"
                + "      1.  X\n"
                + "2.  Item 2\n"
                + "   1.  A\n"
                + "   2.  B\n"
                + "3.  Item 3"
        )

        let markdown = SwiftyMarkdown(string: test.input)

        XCTAssertEqual(
            markdown.attributedString().string,
            test.expectedOutput
        )
    }

    func testThatYAMLMetadataIsRemoved() {
        let yaml = StringTest(
            input: "---\nlayout: page\ntitle: \"Trail Wallet FAQ\"\ndate: 2015-04-22 10:59\ncomments: true\nsharing: true\nliking: false\nfooter: true\nsidebar: false\n---\n# Finally some Markdown!\n\nWith A Heading\n---",
            expectedOutput: "Finally some Markdown!\n\nWith A Heading"
        )
        let md = SwiftyMarkdown(string: yaml.input)
        XCTAssertEqual(md.attributedString().string, yaml.expectedOutput)
        XCTAssertEqual(md.frontMatterAttributes.count, 8)
    }
}

struct StringTest {
    let input: String
    let expectedOutput: String
    var acutalOutput: String = ""
}

struct TokenTest {
    let input: String
    let output: String
    let tokens: [Token]
}

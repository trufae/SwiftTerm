#if os(macOS)
import AppKit
import Testing
@testable import SwiftTerm

@MainActor
struct MacLinkCursorPolicyTests {
    @Test func blockedFileKeepsTheTextCursor() throws {
        let view = TerminalView(frame: NSRect(x: 0, y: 0, width: 400, height: 200))
        let missing = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString + ".txt")
        view.feed(text: "\u{1b}]8;;\(missing.absoluteString)\u{7}x\u{1b}]8;;https://example.test\u{7}y\u{1b}]8;;\u{7}")
        let cell = try #require(view.cellDimension)
        let y = view.bounds.maxY - cell.height / 2
        let filePoint = NSPoint(x: cell.width / 2, y: y)
        let webPoint = NSPoint(x: cell.width * 1.5, y: y)

        #expect(view.pointerCursor(at: filePoint, modifiers: .command) === NSCursor.iBeam)
        #expect(view.pointerCursor(at: webPoint, modifiers: .command) === NSCursor.pointingHand)

        view.usesDefaultLinkPolicyForCursor = false
        #expect(view.pointerCursor(at: filePoint, modifiers: .command) === NSCursor.pointingHand)
    }
}
#endif

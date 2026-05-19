import Foundation

// MARK: - InputSanitizer

/// Stateless, zero-allocation boundary-enforcement utility.
///
/// Applied at every client→Firestore write path and at every Codable decode site
/// where user-supplied strings enter the data pipeline. This is the last line of
/// client-side defence before data reaches the Firestore network layer.
///
/// Schema limits here must mirror the corresponding Firestore security rule sizes.
enum InputSanitizer {

    // MARK: - Schema caps (mirrors firestore.rules)

    static let maxWellnessGoalLength  = 100
    static let maxAgeBracketLength    = 50
    static let maxNotesLength         = 500
    static let maxGenericFieldLength  = 200
    static let maxProtocolTitleLength = 200
    static let maxHistoricalContextLength = 5_000
    static let maxCitationLength      = 400
    static let maxDocumentIDLength    = 128

    // MARK: - Forbidden character set

    /// Characters stripped from all user-supplied plain-text fields:
    /// • ASCII control characters    U+0000–U+001F  (includes null byte, CR, tab injections)
    /// • DEL                         U+007F
    /// • C1 control block            U+0080–U+009F
    /// • Firestore path delimiters   /  .           (prevent path traversal)
    /// • NoSQL operator tokens       ~  *  [  ]     (prevent wildcard injection)
    /// • Unicode private-use area    U+E000–U+F8FF  (BPUA — no legitimate use in display text)
    private static let forbiddenScalars: CharacterSet = {
        var cs = CharacterSet.controlCharacters             // U+0000–U+001F + U+007F
        cs.insert(charactersIn: "/.~*[]")                  // Firestore / injection delimiters
        // C1 controls (some decoders let these through as multi-byte UTF-8)
        if let c1Start = Unicode.Scalar(0x80), let c1End = Unicode.Scalar(0x9F) {
            cs.insert(charactersIn: c1Start...c1End)
        }
        // BMP private-use area
        if let puaStart = Unicode.Scalar(0xE000), let puaEnd = Unicode.Scalar(0xF8FF) {
            cs.insert(charactersIn: puaStart...puaEnd)
        }
        return cs
    }()

    // MARK: - Public API

    /// Returns a sanitized copy of `input`:
    ///  1. Strips all forbidden Unicode scalar values.
    ///  2. Collapses interior whitespace runs to a single space.
    ///  3. Trims leading / trailing whitespace.
    ///  4. Hard-truncates to `maxLength` extended grapheme clusters.
    ///
    /// This function is intentionally non-throwing — a bad input produces a cleaned
    /// output rather than a crash, which keeps the UI responsive while the server-side
    /// Firestore rule rejects the write if the payload still violates constraints.
    static func sanitize(_ input: String, maxLength: Int) -> String {
        // Step 1: strip forbidden scalars
        let stripped = input.unicodeScalars
            .filter { !forbiddenScalars.contains($0) }
            .reduce(into: "") { $0.append(Character($1)) }

        // Step 2: collapse whitespace
        let collapsed = stripped
            .components(separatedBy: .whitespaces)
            .filter { !$0.isEmpty }
            .joined(separator: " ")
            .trimmingCharacters(in: .whitespacesAndNewlines)

        // Step 3: hard truncate (on grapheme cluster boundary — no split surrogate pairs)
        guard collapsed.count > maxLength else { return collapsed }
        return String(collapsed.prefix(maxLength))
    }

    // MARK: - Document ID validation

    /// Returns `true` when `id` is a structurally safe Firestore document ID.
    ///
    /// Firestore rules:
    /// • Must not be empty or exceed `maxDocumentIDLength` characters.
    /// • Must not be the reserved paths `.` or `..`.
    /// • Must not contain `/` (path separator) or null bytes.
    /// • Must not match the reserved string `__.*__` pattern (Firestore system collections).
    static func isValidDocumentID(_ id: String) -> Bool {
        guard !id.isEmpty, id.count <= maxDocumentIDLength else { return false }
        guard id != ".", id != ".." else { return false }
        guard !id.contains("/"), !id.contains("\0") else { return false }
        // Block Firestore system collection pattern __foo__
        let systemPattern = try? NSRegularExpression(pattern: "^__.*__$")
        if systemPattern?.firstMatch(in: id, range: NSRange(id.startIndex..., in: id)) != nil {
            return false
        }
        return true
    }

    // MARK: - Numeric bounds

    /// Clamps `value` to [0, max], guarding against negative or overflow token counts.
    static func clampTokenCount(_ value: Int, max: Int = 10_000) -> Int {
        Swift.max(0, Swift.min(value, max))
    }
}

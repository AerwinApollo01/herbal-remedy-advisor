import XCTest

// Tests the password strength algorithm from LoginScreen.PasswordStrength.
// The enum is private to LoginScreen, so we replicate the exact same logic here.
// If LoginScreen's algorithm changes, update this file to match.
final class PasswordStrengthLogicTests: XCTestCase {

    // Mirrors LoginScreen.passwordStrength computed var (minus the isSignUp guard)
    private func strength(for password: String) -> String {
        guard !password.isEmpty else { return "none" }
        let hasDigit   = password.rangeOfCharacter(from: .decimalDigits) != nil
        let hasSpecial = password.unicodeScalars.contains { !CharacterSet.alphanumerics.contains($0) }
        if password.count < 8                                    { return "Weak"   }
        if password.count >= 12 || (hasDigit && hasSpecial)      { return "Strong" }
        return "Fair"
    }

    // MARK: - Weak (< 8 chars)

    func test_1char_isWeak()  { XCTAssertEqual(strength(for: "a"),       "Weak") }
    func test_7chars_isWeak() { XCTAssertEqual(strength(for: "abcdefg"), "Weak") }

    // MARK: - Fair (8–11 chars, no digit+special combo)

    func test_8charsNoComplexity_isFair() {
        XCTAssertEqual(strength(for: "abcdefgh"), "Fair",
                       "8 chars without digit AND special → Fair")
    }

    func test_8charsDigitOnly_isFair() {
        XCTAssertEqual(strength(for: "abcde123"), "Fair",
                       "8 chars with digit but no special → Fair")
    }

    func test_11charsNoComplexity_isFair() {
        XCTAssertEqual(strength(for: "abcdefghijk"), "Fair",
                       "11 chars with no digit+special combo → Fair (< 12 threshold)")
    }

    func test_11charsDigitOnly_isFair() {
        XCTAssertEqual(strength(for: "abcdefgh123"), "Fair",
                       "11 chars digit-only → Fair")
    }

    // MARK: - Strong (≥12 chars OR (digit AND special))

    func test_12charsAllAlpha_isStrong() {
        XCTAssertEqual(strength(for: "abcdefghijkl"), "Strong",
                       "Exactly 12 alpha chars → Strong (count >= 12 rule)")
    }

    func test_14chars_isStrong() {
        XCTAssertEqual(strength(for: "abcdefghijklmn"), "Strong",
                       "14 alpha chars → Strong")
    }

    func test_8charsDigitAndSpecial_isStrong() {
        XCTAssertEqual(strength(for: "abcde1!a"), "Strong",
                       "8 chars with both a digit AND a special → Strong (complexity rule)")
    }

    func test_11charsDigitAndSpecial_isStrong() {
        XCTAssertEqual(strength(for: "abcdefgh1!a"), "Strong",
                       "11 chars with digit AND special → Strong (complexity rule applies before 12-char rule)")
    }

    // MARK: - Edge cases

    func test_emptyPassword_isNone() {
        XCTAssertEqual(strength(for: ""), "none",
                       "Empty password has no strength (guarded by isSignUp && !password.isEmpty in the view)")
    }

    func test_specialCharOnly_8chars_isFair() {
        // hasDigit=false, hasSpecial=true → digit&&special is false → not ≥12 chars → Fair
        XCTAssertEqual(strength(for: "!!!!!!!!"), "Fair",
                       "8 special-only chars (no digit) → Fair, not Strong")
    }

    func test_exactThreshold_12chars_isStrong() {
        let exactly12 = String(repeating: "a", count: 12)
        XCTAssertEqual(strength(for: exactly12), "Strong")
    }

    func test_oneBelowThreshold_11chars_isFair() {
        let exactly11 = String(repeating: "a", count: 11)
        XCTAssertEqual(strength(for: exactly11), "Fair")
    }
}

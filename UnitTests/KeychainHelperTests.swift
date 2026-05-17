import XCTest
@testable import HerbalRemedyAdvisor

final class KeychainHelperTests: XCTestCase {

    private let testKey = "test_keychain_key_\(UUID().uuidString)"
    private let testKey2 = "test_keychain_key2_\(UUID().uuidString)"

    override func tearDown() {
        super.tearDown()
        KeychainHelper.delete(key: testKey)
        KeychainHelper.delete(key: testKey2)
    }

    // MARK: - Save & Load

    func test_save_returnsTrueOnSuccess() {
        XCTAssertTrue(KeychainHelper.save("hello", for: testKey))
    }

    func test_load_returnsNilForMissingKey() {
        XCTAssertNil(KeychainHelper.load(key: testKey))
    }

    func test_save_thenLoad_returnsOriginalValue() {
        KeychainHelper.save("remedy_user_123", for: testKey)
        XCTAssertEqual(KeychainHelper.load(key: testKey), "remedy_user_123")
    }

    func test_save_overwritesPreviousValue() {
        KeychainHelper.save("first_value", for: testKey)
        KeychainHelper.save("second_value", for: testKey)
        XCTAssertEqual(KeychainHelper.load(key: testKey), "second_value")
    }

    func test_save_preservesUnicodeCharacters() {
        let name = "María José"
        KeychainHelper.save(name, for: testKey)
        XCTAssertEqual(KeychainHelper.load(key: testKey), name)
    }

    func test_save_handlesEmptyString() {
        KeychainHelper.save("", for: testKey)
        XCTAssertEqual(KeychainHelper.load(key: testKey), "")
    }

    // MARK: - Delete

    func test_delete_removesExistingEntry() {
        KeychainHelper.save("to_be_deleted", for: testKey)
        KeychainHelper.delete(key: testKey)
        XCTAssertNil(KeychainHelper.load(key: testKey))
    }

    func test_delete_onMissingKey_doesNotCrash() {
        KeychainHelper.delete(key: testKey)
    }

    // MARK: - Key isolation

    func test_differentKeys_areStoredIndependently() {
        KeychainHelper.save("alpha", for: testKey)
        KeychainHelper.save("beta", for: testKey2)
        XCTAssertEqual(KeychainHelper.load(key: testKey), "alpha")
        XCTAssertEqual(KeychainHelper.load(key: testKey2), "beta")
    }

    func test_delete_onlyAffectsTargetKey() {
        KeychainHelper.save("keep_me", for: testKey)
        KeychainHelper.save("delete_me", for: testKey2)
        KeychainHelper.delete(key: testKey2)
        XCTAssertEqual(KeychainHelper.load(key: testKey), "keep_me")
        XCTAssertNil(KeychainHelper.load(key: testKey2))
    }
}

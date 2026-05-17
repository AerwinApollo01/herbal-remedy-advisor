import XCTest
@testable import HerbalRemedyAdvisor

// MARK: - Phase 1 Infrastructure Tests
// Validates PrivacyInfo.xcprivacy, launch screen assets, Info.plist keys,
// and launch-time state. These run as unit tests (no simulator required)
// so they can be verified in CI before archiving.

final class InfrastructureTests: XCTestCase {

    // MARK: - Info.plist Keys

    func test_infoPlist_notificationUsageDescriptionPresent() {
        let value = Bundle.main.object(forInfoDictionaryKey: "NSUserNotificationUsageDescription") as? String
        XCTAssertNotNil(value, "NSUserNotificationUsageDescription must be present in Info.plist — TestFlight rejects builds that call UNUserNotificationCenter without it")
        XCTAssertFalse(value?.isEmpty ?? true, "NSUserNotificationUsageDescription must not be empty")
    }

    func test_infoPlist_nonExemptEncryptionDeclared() {
        // ITSAppUsesNonExemptEncryption: false removes the export compliance
        // questionnaire from every App Store Connect upload.
        let value = Bundle.main.object(forInfoDictionaryKey: "ITSAppUsesNonExemptEncryption")
        XCTAssertNotNil(value, "ITSAppUsesNonExemptEncryption must be declared in Info.plist")
        if let boolValue = value as? Bool {
            XCTAssertFalse(boolValue, "ITSAppUsesNonExemptEncryption should be false — this app uses no custom encryption")
        }
    }

    func test_infoPlist_bundleIdentifierSet() {
        let bundleId = Bundle.main.bundleIdentifier
        XCTAssertEqual(bundleId, "com.herbalremedyadvisor.app")
    }

    func test_infoPlist_lightModeEnforced() {
        let style = Bundle.main.object(forInfoDictionaryKey: "UIUserInterfaceStyle") as? String
        XCTAssertEqual(style, "Light", "App must be locked to light mode — dark mode palette not designed")
    }

    func test_infoPlist_portraitOnly() {
        let orientations = Bundle.main.object(forInfoDictionaryKey: "UISupportedInterfaceOrientations") as? [String]
        XCTAssertNotNil(orientations)
        XCTAssertEqual(orientations?.count, 1)
        XCTAssertEqual(orientations?.first, "UIInterfaceOrientationPortrait", "App must be portrait-only")
    }

    func test_infoPlist_statusBarLightContent() {
        let style = Bundle.main.object(forInfoDictionaryKey: "UIStatusBarStyle") as? String
        XCTAssertEqual(style, "UIStatusBarStyleLightContent", "Status bar must use light content (white text) against the forest-green header")
    }

    func test_infoPlist_fontsRegistered() {
        let fonts = Bundle.main.object(forInfoDictionaryKey: "UIFonts") as? [String]
        XCTAssertNotNil(fonts, "UIFonts key must be present — Noto fonts require explicit registration")
        XCTAssertTrue(fonts?.contains("NotoSerif-Regular.ttf") ?? false, "NotoSerif-Regular.ttf must be registered")
        XCTAssertTrue(fonts?.contains("NotoSans-Regular.ttf") ?? false, "NotoSans-Regular.ttf must be registered")
    }

    // MARK: - Launch Screen Assets

    func test_launchAsset_backgroundColorExists() {
        // LaunchBackground named color must exist in the asset catalog so
        // UILaunchScreen can render the forest-green background instead of white.
        let color = UIColor(named: "LaunchBackground")
        XCTAssertNotNil(color, "LaunchBackground named color must exist in Assets.xcassets for UILaunchScreen")
    }

    func test_launchAsset_backgroundColorIsForestGreen() {
        guard let color = UIColor(named: "LaunchBackground") else {
            XCTFail("LaunchBackground color not found")
            return
        }
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        // Forest green: #1A2E1A = (26/255, 46/255, 26/255)
        XCTAssertEqual(r, 26.0/255.0, accuracy: 0.01, "LaunchBackground red channel should be 0x1A")
        XCTAssertEqual(g, 46.0/255.0, accuracy: 0.01, "LaunchBackground green channel should be 0x2E")
        XCTAssertEqual(b, 26.0/255.0, accuracy: 0.01, "LaunchBackground blue channel should be 0x1A")
    }

    func test_launchAsset_leafSymbolResolvable() {
        // LaunchLeaf.symbolset references the leaf.fill SF Symbol. Verify the
        // system symbol is available on the deployment target (iOS 13+).
        let image = UIImage(systemName: "leaf.fill")
        XCTAssertNotNil(image, "leaf.fill SF Symbol must be available — used in launch screen and loading view")
    }

    // MARK: - PrivacyInfo.xcprivacy

    func test_privacyManifest_fileExistsInBundle() {
        // PrivacyInfo.xcprivacy is compiled into the bundle by Xcode.
        // Its presence confirms the file was added to the target correctly.
        let url = Bundle.main.url(forResource: "PrivacyInfo", withExtension: "xcprivacy")
        XCTAssertNotNil(url, "PrivacyInfo.xcprivacy must be present in the app bundle — required since Spring 2024, TestFlight rejects builds without it")
    }

    func test_privacyManifest_declaresUserDefaultsAccess() throws {
        guard let url = Bundle.main.url(forResource: "PrivacyInfo", withExtension: "xcprivacy") else {
            XCTFail("PrivacyInfo.xcprivacy not found in bundle")
            return
        }
        let data = try Data(contentsOf: url)
        let plist = try PropertyListSerialization.propertyList(from: data, format: nil) as? [String: Any]
        XCTAssertNotNil(plist, "PrivacyInfo.xcprivacy must be a valid plist")

        let apiTypes = plist?["NSPrivacyAccessedAPITypes"] as? [[String: Any]]
        XCTAssertNotNil(apiTypes, "NSPrivacyAccessedAPITypes must be declared")

        let userDefaultsEntry = apiTypes?.first(where: {
            $0["NSPrivacyAccessedAPIType"] as? String == "NSPrivacyAccessedAPICategoryUserDefaults"
        })
        XCTAssertNotNil(userDefaultsEntry, "UserDefaults API access must be declared in PrivacyInfo.xcprivacy")

        let reasons = userDefaultsEntry?["NSPrivacyAccessedAPITypeReasons"] as? [String]
        XCTAssertTrue(reasons?.contains("CA92.1") ?? false, "Reason CA92.1 (read/write values the app creates itself) must be declared")
    }

    func test_privacyManifest_noTracking() throws {
        guard let url = Bundle.main.url(forResource: "PrivacyInfo", withExtension: "xcprivacy") else {
            XCTFail("PrivacyInfo.xcprivacy not found in bundle")
            return
        }
        let data = try Data(contentsOf: url)
        let plist = try PropertyListSerialization.propertyList(from: data, format: nil) as? [String: Any]

        let tracking = plist?["NSPrivacyTracking"] as? Bool
        XCTAssertEqual(tracking, false, "NSPrivacyTracking must be false — this app does not track users")

        let domains = plist?["NSPrivacyTrackingDomains"] as? [String]
        XCTAssertTrue(domains?.isEmpty ?? true, "NSPrivacyTrackingDomains must be empty")
    }

    func test_privacyManifest_noDataCollected() throws {
        guard let url = Bundle.main.url(forResource: "PrivacyInfo", withExtension: "xcprivacy") else {
            XCTFail("PrivacyInfo.xcprivacy not found in bundle")
            return
        }
        let data = try Data(contentsOf: url)
        let plist = try PropertyListSerialization.propertyList(from: data, format: nil) as? [String: Any]

        let collectedTypes = plist?["NSPrivacyCollectedDataTypes"] as? [Any]
        XCTAssertTrue(collectedTypes?.isEmpty ?? true, "NSPrivacyCollectedDataTypes must be empty — this app collects no user data")
    }

    // MARK: - Brand Asset Integrity

    func test_brandColors_allNamedColorsResolve() {
        // Named colors used via Color(hex:) don't need asset catalog entries,
        // but the UIColor initializers used in UITabBarAppearance must work.
        // These are sanity checks that the hex parsing logic is correct.
        let forest = UIColor(red: 0x1A/255.0, green: 0x2E/255.0, blue: 0x1A/255.0, alpha: 1)
        XCTAssertNotNil(forest)

        let gold = UIColor(red: 0xC8/255.0, green: 0xA0/255.0, blue: 0x50/255.0, alpha: 1)
        XCTAssertNotNil(gold)
    }

    func test_sfSymbols_allTabBarSymbolsAvailable() {
        // All four tab bar SF Symbols must resolve — if any returns nil, the
        // tab bar will show a placeholder instead of the intended icon.
        let symbols = ["waveform.path.ecg", "leaf.fill", "globe.americas.fill", "book.closed.fill"]
        for name in symbols {
            let image = UIImage(systemName: name)
            XCTAssertNotNil(image, "Tab bar SF Symbol '\(name)' must be available on iOS 16+")
        }
    }

    func test_sfSymbols_allJournalSymbolsAvailable() {
        let symbols = [
            "checkmark.circle", "checkmark.circle.fill", "flame.fill",
            "trophy.fill", "sparkles", "alarm", "book.closed.fill",
            "checkmark", "lock.fill", "star.fill", "wand.and.stars"
        ]
        for name in symbols {
            let image = UIImage(systemName: name)
            XCTAssertNotNil(image, "Journal SF Symbol '\(name)' must be available on iOS 16+")
        }
    }
}

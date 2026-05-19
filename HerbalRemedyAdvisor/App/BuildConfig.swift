// MARK: - BuildConfig

/// Compile-time build flags for Nys.
///
/// To restore standard production gating before App Store submission:
///   Set `isTestFlightBetaBuild = false`
///
/// Nothing else needs to change — all gating logic reads this flag
/// and restores automatically.
enum BuildConfig {

    /// When `true`, all protocol archive lock gates are bypassed globally,
    /// granting every tester unrestricted read access to every protocol
    /// regardless of purchase state or token balance.
    ///
    /// SET TO `false` BEFORE PRODUCTION / APP STORE SUBMISSION.
    static let isTestFlightBetaBuild: Bool = true
}

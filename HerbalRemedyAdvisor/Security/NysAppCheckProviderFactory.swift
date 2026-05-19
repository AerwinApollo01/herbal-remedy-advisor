import FirebaseAppCheck
import FirebaseCore

// MARK: - NysAppCheckProviderFactory

/// Selects the correct Firebase App Check attestation provider for the runtime environment.
///
/// Attestation chain:
///   Physical device, iOS 14+  → App Attest  (hardware-rooted, cryptographically signed
///                                             device identity issued by Apple's CA)
///   Physical device, iOS < 14 → DeviceCheck  (token-based hardware attestation via APNs)
///   Simulator / DEBUG build   → AppCheckDebugProvider  (injected token, dev-only)
///
/// Effect:
/// Every Firestore request carries a verified App Check token in its header.
/// Requests lacking a valid token are blocked server-side regardless of API key validity,
/// preventing bot scrapers, desktop curl scripts, or credential-stuffed automation from
/// reaching our Firestore billing surface.
///
/// Setup (one-time, per engineer):
///   1. In Firebase Console → App Check → Apps → register "HerbalRemedyAdvisor"
///      with provider "App Attest".
///   2. For local simulator testing: in Xcode Scheme → Run → Environment Variables,
///      add  `FIREBASE_APP_CHECK_DEBUG_TOKEN`  set to the token printed in the console
///      on first simulator launch (copy from Xcode output, register it in Firebase Console
///      under App Check → Apps → your app → Manage debug tokens).
///   3. After verifying token flow, enable enforcement in Firebase Console.
final class NysAppCheckProviderFactory: NSObject, AppCheckProviderFactory {

    func createProvider(with app: FirebaseApp) -> AppCheckProvider? {
        #if targetEnvironment(simulator)
        // Simulator cannot execute the Secure Enclave operations required by App Attest.
        // AppCheckDebugProvider uses a developer-registered token instead.
        // NEVER ship a release build with this branch reachable — the #if guard ensures
        // it is stripped at compile time for non-simulator targets.
        return AppCheckDebugProvider(app: app)

        #else
        if #available(iOS 14.0, *) {
            // App Attest: hardware-rooted attestation using the device Secure Enclave.
            // Each assertion is signed with a key generated on-device and certified by Apple.
            return AppAttestProvider(app: app)
        } else {
            // DeviceCheck: APNs-backed token attestation for pre-iOS-14 devices.
            return DeviceCheckProvider(app: app)
        }
        #endif
    }
}

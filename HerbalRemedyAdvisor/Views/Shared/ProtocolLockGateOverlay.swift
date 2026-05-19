import StoreKit
import SwiftUI

// MARK: - ProtocolLockGateOverlay

/// High-end editorial lock mask applied over gated protocol content.
///
/// Shows:
/// - Muted, desaturated blur behind the overlay (cream-and-sage stays visible)
/// - A centered lock icon + label explaining chronological unlock
/// - Two immediate access paths: spend 1 token OR purchase lifetime archive
///
/// Injected dependencies:
/// - `userProfileVM`: checks token balance and performs spend action
/// - `purchaseManager`: drives StoreKit 2 purchase sheet
/// - `protocolID`: the Firestore document ID being gated
struct ProtocolLockGateOverlay: View {

    // MARK: - Input

    let protocolTitle: String
    let protocolID: String

    // MARK: - Environment

    @EnvironmentObject private var userProfileVM:   UserProfileViewModel
    @EnvironmentObject private var purchaseManager: PurchaseManager
    @EnvironmentObject private var appConfig:       AppConfigService

    // MARK: - Local state

    @State private var isPurchasing:  Bool   = false
    @State private var isSpending:    Bool   = false
    @State private var errorMessage:  String? = nil
    @State private var showRestoreConfirmation: Bool = false

    // MARK: - Body

    var body: some View {
        ZStack {
            // Desaturated blur base — keeps the brand palette ghosted underneath
            Rectangle()
                .fill(.ultraThinMaterial)
                .overlay(Color.forest.opacity(0.65))

            VStack(spacing: 0) {

                // MARK: Lock icon
                ZStack {
                    Circle()
                        .fill(Color.cream.opacity(0.08))
                        .frame(width: 72, height: 72)
                    Image(systemName: "lock.fill")
                        .font(.system(size: 28, weight: .semibold))
                        .foregroundColor(.mist.opacity(0.85))
                }
                .padding(.bottom, 20)

                // MARK: Volume label
                Text(protocolTitle.uppercased())
                    .font(.notoSans(size: 9, weight: .semibold))
                    .foregroundColor(.mist.opacity(0.5))
                    .kerning(2)
                    .padding(.bottom, 8)

                // MARK: Gate descriptor
                Text("This volume unlocks naturally\nupon completing your active cycle.")
                    .font(.notoSerif(size: 15))
                    .foregroundColor(.cream.opacity(0.88))
                    .multilineTextAlignment(.center)
                    .lineSpacing(5)
                    .padding(.horizontal, 36)
                    .padding(.bottom, 28)

                // MARK: Divider
                Rectangle()
                    .fill(Color.mist.opacity(0.15))
                    .frame(height: 1)
                    .padding(.horizontal, 40)
                    .padding(.bottom, 24)

                // MARK: Access paths
                Text("IMMEDIATE ACCESS")
                    .font(.notoSans(size: 9, weight: .semibold))
                    .foregroundColor(.mist.opacity(0.4))
                    .kerning(1.5)
                    .padding(.bottom, 16)

                // Token spend button
                if userProfileVM.availableTokens > 0 {
                    tokenButton
                        .padding(.bottom, 10)
                }

                // StoreKit purchase button
                lifetimeButton
                    .padding(.bottom, 14)

                // Restore
                Button {
                    showRestoreConfirmation = true
                } label: {
                    Text("Restore Purchase")
                        .font(.notoSans(size: 11))
                        .foregroundColor(.mist.opacity(0.4))
                        .underline()
                }
                .confirmationDialog("Restore previous purchase?",
                                    isPresented: $showRestoreConfirmation,
                                    titleVisibility: .visible) {
                    Button("Restore") {
                        Task {
                            let restored = await purchaseManager.restorePurchases()
                            if restored { await userProfileVM.applyLifetimeUnlock() }
                        }
                    }
                    Button("Cancel", role: .cancel) {}
                }

                // Error banner
                if let err = errorMessage ?? purchaseManager.purchaseError {
                    Text(err)
                        .font(.notoSans(size: 11))
                        .foregroundColor(.gold)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                        .padding(.top, 14)
                }
            }
            .padding(.vertical, 40)
        }
        .ignoresSafeArea()
    }

    // MARK: - Token button

    private var tokenButton: some View {
        Button {
            guard !isSpending else { return }
            isSpending = true
            errorMessage = nil
            Task {
                await userProfileVM.spendTokenToUnlock(protocolID: protocolID)
                isSpending = false
            }
        } label: {
            HStack(spacing: 10) {
                if isSpending {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(.forest)
                        .scaleEffect(0.8)
                } else {
                    Image(systemName: "circle.hexagongrid.fill")
                        .font(.system(size: 14))
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text("Unlock with 1 Token")
                        .font(.notoSans(size: 13, weight: .semibold))
                    Text("\(userProfileVM.availableTokens) token\(userProfileVM.availableTokens == 1 ? "" : "s") available")
                        .font(.notoSans(size: 10))
                        .opacity(0.7)
                }
                Spacer()
            }
            .foregroundColor(.forest)
            .padding(.horizontal, 20)
            .padding(.vertical, 14)
            .background(Color.cream)
            .cornerRadius(14)
            .shadow(color: .black.opacity(0.15), radius: 8, y: 3)
        }
        .padding(.horizontal, 28)
        .disabled(isSpending)
    }

    // MARK: - Lifetime purchase button

    private var lifetimeButton: some View {
        Button {
            guard !isPurchasing else { return }
            isPurchasing = true
            errorMessage = nil
            Task {
                let result = await purchaseManager.purchaseLifetimeArchive()
                if result == .success {
                    await userProfileVM.applyLifetimeUnlock()
                } else if case .failed(let msg) = result {
                    errorMessage = msg
                }
                isPurchasing = false
            }
        } label: {
            HStack(spacing: 10) {
                if isPurchasing {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(.white)
                        .scaleEffect(0.8)
                } else {
                    Image(systemName: "archivebox.fill")
                        .font(.system(size: 14))
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text("Unlock Full Archive")
                        .font(.notoSans(size: 13, weight: .semibold))
                    Text("One-time · \(appConfig.archiveUnlockPriceLabel) · All volumes forever")
                        .font(.notoSans(size: 10))
                        .opacity(0.8)
                }
                Spacer()
            }
            .foregroundColor(.white)
            .padding(.horizontal, 20)
            .padding(.vertical, 14)
            .background(
                LinearGradient(
                    colors: [Color.sage, Color.forest],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(14)
            .shadow(color: Color.forest.opacity(0.4), radius: 8, y: 3)
        }
        .padding(.horizontal, 28)
        .disabled(isPurchasing)
    }
}

// MARK: - LockGate ViewModifier

/// Apply `.protocolLockGate(isLocked:...)` on any scrollable content view
/// to conditionally overlay the gate mask.
struct ProtocolLockGateModifier: ViewModifier {
    let isLocked: Bool
    let protocolTitle: String
    let protocolID: String

    func body(content: Content) -> some View {
        ZStack {
            content
                .saturation(isLocked ? 0.15 : 1.0)
                .blur(radius: isLocked ? 2 : 0)
                .allowsHitTesting(!isLocked)
                .animation(.easeInOut(duration: 0.25), value: isLocked)

            if isLocked {
                ProtocolLockGateOverlay(
                    protocolTitle: protocolTitle,
                    protocolID: protocolID
                )
                .transition(.opacity.combined(with: .scale(scale: 0.98)))
            }
        }
    }
}

extension View {
    func protocolLockGate(isLocked: Bool, title: String, protocolID: String) -> some View {
        modifier(ProtocolLockGateModifier(
            isLocked: isLocked,
            protocolTitle: title,
            protocolID: protocolID
        ))
    }
}

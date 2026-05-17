import SwiftUI

struct LoginScreen: View {
    @EnvironmentObject var authVM: AuthViewModel

    let isRevoked: Bool

    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var isSignUp: Bool = false
    @FocusState private var focus: Field?

    private enum Field { case email, password, confirm }

    // MARK: - Validation

    private var emailValid: Bool {
        email.contains("@") && email.contains(".")
    }

    private var passwordValid: Bool {
        password.count >= 6
    }

    private var confirmValid: Bool {
        !isSignUp || password == confirmPassword
    }

    private var canSubmit: Bool {
        emailValid && passwordValid && confirmValid && !authVM.isLoading
    }

    // MARK: - Password strength (sign-up only)

    private enum PasswordStrength {
        case none, weak, fair, strong

        var label: String {
            switch self {
            case .none:   return ""
            case .weak:   return "Weak"
            case .fair:   return "Fair"
            case .strong: return "Strong"
            }
        }
        var color: Color {
            switch self {
            case .none:   return .clear
            case .weak:   return Color(red: 0.85, green: 0.3, blue: 0.3)
            case .fair:   return Color(red: 0.9,  green: 0.6, blue: 0.1)
            case .strong: return Color(red: 0.25, green: 0.6, blue: 0.3)
            }
        }
        var barFraction: CGFloat {
            switch self { case .none: return 0; case .weak: return 0.33; case .fair: return 0.66; case .strong: return 1.0 }
        }
    }

    private var passwordStrength: PasswordStrength {
        guard isSignUp, !password.isEmpty else { return .none }
        let hasDigit   = password.rangeOfCharacter(from: .decimalDigits) != nil
        let hasSpecial = password.unicodeScalars.contains { !CharacterSet.alphanumerics.contains($0) }
        if password.count < 8 { return .weak }
        if password.count >= 12 || (hasDigit && hasSpecial) { return .strong }
        return .fair
    }

    // MARK: - Body

    var body: some View {
        ZStack {
            LinearGradient(colors: [.forest, .moss], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {

                    // Logo + wordmark
                    Image(systemName: "leaf.fill")
                        .font(.system(size: 44))
                        .foregroundColor(.fern)
                        .padding(.top, 72)
                        .padding(.bottom, 12)

                    Text("Nise")
                        .font(.notoSerif(size: 48, weight: .bold))
                        .foregroundColor(.cream)
                        .tracking(4)

                    Text("Ancient wisdom, daily practice")
                        .font(.notoSans(size: 13))
                        .foregroundColor(.mist.opacity(0.75))
                        .tracking(0.5)
                        .padding(.top, 8)
                        .padding(.bottom, 44)

                    // Notices
                    if isRevoked {
                        notice(icon: "exclamationmark.circle",
                               text: "Your session expired. Please sign in again.",
                               color: .gold)
                        .padding(.bottom, 16)
                    }

                    if let error = authVM.signInError {
                        notice(icon: "exclamationmark.circle.fill",
                               text: error,
                               color: .gold)
                        .padding(.bottom, 16)
                    }

                    if authVM.passwordResetSent {
                        notice(icon: "checkmark.circle.fill",
                               text: "Reset link sent — check your inbox.",
                               color: .fern)
                        .padding(.bottom, 16)
                    }

                    if authVM.verificationEmailSent {
                        notice(icon: "envelope.badge.fill",
                               text: "Verification email sent — check your inbox before signing in.",
                               color: .fern)
                        .padding(.bottom, 16)
                    }

                    if !authVM.isEmailVerified && !isSignUp && authVM.state != .loading {
                        HStack(spacing: 8) {
                            notice(icon: "exclamationmark.shield",
                                   text: "Your email isn't verified yet.",
                                   color: .gold)
                            Button("Resend") { authVM.resendVerification() }
                                .font(.notoSans(size: 13, weight: .semibold))
                                .foregroundColor(.gold)
                                .underline()
                                .padding(.trailing, 40)
                        }
                        .padding(.bottom, 16)
                    }

                    // Form
                    VStack(spacing: 12) {
                        inputField(placeholder: "Email address",
                                   text: $email,
                                   type: .emailAddress,
                                   content: .emailAddress,
                                   secure: false,
                                   field: .email)

                        inputField(placeholder: "Password",
                                   text: $password,
                                   type: .default,
                                   content: .password,
                                   secure: true,
                                   field: .password)

                        // Password strength (sign-up only)
                        if isSignUp && !password.isEmpty {
                            strengthBar
                        }

                        if isSignUp {
                            inputField(placeholder: "Confirm password",
                                       text: $confirmPassword,
                                       type: .default,
                                       content: .password,
                                       secure: true,
                                       field: .confirm)

                            if !confirmPassword.isEmpty && !confirmValid {
                                Text("Passwords don't match.")
                                    .font(.notoSans(size: 12))
                                    .foregroundColor(.gold)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.horizontal, 40)
                            }
                        }
                    }
                    .padding(.bottom, 20)

                    // Remember me
                    HStack(spacing: 10) {
                        Toggle("", isOn: $authVM.rememberMe)
                            .labelsHidden()
                            .tint(.fern)
                        Text("Remember me")
                            .font(.notoSans(size: 13))
                            .foregroundColor(.mist)
                        Spacer()
                    }
                    .padding(.horizontal, 44)
                    .padding(.bottom, 24)

                    // Primary action
                    Button {
                        focus = nil
                        if isSignUp {
                            authVM.signUp(email: email, password: password)
                        } else {
                            authVM.signIn(email: email, password: password)
                        }
                    } label: {
                        HStack(spacing: 10) {
                            if authVM.isLoading {
                                ProgressView().tint(.forest)
                            } else {
                                Text(isSignUp ? "Create Account" : "Sign In")
                                    .font(.notoSerif(size: 16))
                                Image(systemName: "arrow.right")
                                    .font(.system(size: 13, weight: .semibold))
                            }
                        }
                        .foregroundColor(.forest)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 17)
                        .background(canSubmit ? Color.cream : Color.cream.opacity(0.45))
                        .cornerRadius(16)
                        .shadow(color: .black.opacity(0.2), radius: 8, y: 4)
                    }
                    .disabled(!canSubmit)
                    .padding(.horizontal, 40)
                    .padding(.bottom, 14)

                    // Forgot password (sign-in mode only)
                    if !isSignUp {
                        Button {
                            focus = nil
                            authVM.sendPasswordReset(email: email)
                        } label: {
                            Text("Forgot password?")
                                .font(.notoSans(size: 13))
                                .foregroundColor(.mist.opacity(0.75))
                                .underline()
                        }
                        .disabled(authVM.isLoading)
                        .padding(.bottom, 32)
                    } else {
                        Spacer().frame(height: 32)
                    }

                    // Toggle mode
                    Button {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            isSignUp.toggle()
                            authVM.signInError = nil
                            authVM.passwordResetSent = false
                            authVM.verificationEmailSent = false
                            confirmPassword = ""
                        }
                    } label: {
                        HStack(spacing: 4) {
                            Text(isSignUp ? "Already have an account?" : "Don't have an account?")
                                .foregroundColor(.mist.opacity(0.7))
                            Text(isSignUp ? "Sign In" : "Create one")
                                .foregroundColor(.cream)
                                .fontWeight(.semibold)
                        }
                        .font(.notoSans(size: 13))
                    }
                    .padding(.bottom, 48)
                }
            }
        }
        .onTapGesture { focus = nil }
    }

    // MARK: - Password strength bar

    private var strengthBar: some View {
        let strength = passwordStrength
        return VStack(alignment: .leading, spacing: 4) {
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.cream.opacity(0.2))
                        .frame(height: 4)
                    RoundedRectangle(cornerRadius: 2)
                        .fill(strength.color)
                        .frame(width: geo.size.width * strength.barFraction, height: 4)
                        .animation(.easeInOut(duration: 0.25), value: strength.barFraction)
                }
            }
            .frame(height: 4)

            Text(strength.label)
                .font(.notoSans(size: 11))
                .foregroundColor(strength.color)
        }
        .padding(.horizontal, 40)
    }

    // MARK: - Helpers

    @ViewBuilder
    private func inputField(placeholder: String,
                            text: Binding<String>,
                            type: UIKeyboardType,
                            content: UITextContentType,
                            secure: Bool,
                            field: Field) -> some View {
        Group {
            if secure {
                SecureField(placeholder, text: text)
            } else {
                TextField(placeholder, text: text)
                    .keyboardType(type)
                    .textContentType(content)
                    .autocapitalization(.none)
                    .autocorrectionDisabled()
            }
        }
        .focused($focus, equals: field)
        .submitLabel(field == .password && !isSignUp ? .go : .next)
        .onSubmit {
            switch field {
            case .email:    focus = .password
            case .password: focus = isSignUp ? .confirm : nil
                            if !isSignUp { submitSignIn() }
            case .confirm:  focus = nil
            }
        }
        .font(.notoSans(size: 15))
        .foregroundColor(.forest)
        .padding(.vertical, 14)
        .padding(.horizontal, 16)
        .background(Color.cream.opacity(0.95))
        .cornerRadius(12)
        .padding(.horizontal, 40)
    }

    @ViewBuilder
    private func notice(icon: String, text: String, color: Color) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(color)
                .padding(.top, 1)
            Text(text)
                .font(.notoSans(size: 13))
                .foregroundColor(color)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.horizontal, 40)
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func submitSignIn() {
        guard canSubmit else { return }
        authVM.signIn(email: email, password: password)
    }
}

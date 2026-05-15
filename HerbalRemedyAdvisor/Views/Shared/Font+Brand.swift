import SwiftUI

extension Font {
    // Both notoSerif and notoSans use variable fonts — weight/style applied via SwiftUI modifiers.
    static func notoSerif(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        .custom("NotoSerif-Regular", size: size).weight(weight)
    }

    static func notoSans(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        .custom("NotoSans-Regular", size: size).weight(weight)
    }
}

struct NotoSerifItalicModifier: ViewModifier {
    let size: CGFloat
    func body(content: Content) -> some View {
        content
            .font(.custom("NotoSerif-Regular", size: size))
            .italic()
    }
}

extension View {
    func notoSerifItalic(size: CGFloat) -> some View {
        modifier(NotoSerifItalicModifier(size: size))
    }
}

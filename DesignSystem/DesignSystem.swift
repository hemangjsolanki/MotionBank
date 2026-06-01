import SwiftUI

struct AppColors {
    static let background = Color("Background", bundle: nil) // Will fallback if asset not present
    static let cardBackground = Color.black.opacity(0.8)
    static let textPrimary = Color.primary
    static let textSecondary = Color.secondary
    static let accent = Color.blue
    
    // Dynamic Colors to support dark mode
    static var dynamicBackground: Color {
        Color(UIColor.systemBackground)
    }
}

struct GlassmorphismModifier: ViewModifier {
    var cornerRadius: CGFloat
    
    func body(content: Content) -> some View {
        content
            .background(
                .ultraThinMaterial,
                in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    .blendMode(.overlay)
            )
            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
}

extension View {
    func glassmorphism(cornerRadius: CGFloat = 20) -> some View {
        self.modifier(GlassmorphismModifier(cornerRadius: cornerRadius))
    }
}

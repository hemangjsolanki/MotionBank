import SwiftUI

struct ShimmerView: View {
    @State private var isAnimating = false
    
    var body: some View {
        LinearGradient(
            colors: [
                Color.gray.opacity(0.3),
                Color.gray.opacity(0.1),
                Color.gray.opacity(0.3)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .mask(
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [.clear, .white, .clear],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .rotationEffect(.degrees(70))
                .offset(x: isAnimating ? 400 : -400)
        )
        .onAppear {
            withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                isAnimating = true
            }
        }
    }
}

struct ShimmerLoadingModifier: ViewModifier {
    var isLoading: Bool
    
    func body(content: Content) -> some View {
        if isLoading {
            content
                .overlay(ShimmerView().mask(content))
                .redacted(reason: .placeholder)
        } else {
            content
        }
    }
}

extension View {
    func shimmer(when isLoading: Bool) -> some View {
        self.modifier(ShimmerLoadingModifier(isLoading: isLoading))
    }
}

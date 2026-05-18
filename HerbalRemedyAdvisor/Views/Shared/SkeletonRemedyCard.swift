import SwiftUI

struct SkeletonRemedyCard: View {
    @State private var shimmerOn = true

    var body: some View {
        VStack(spacing: 0) {
            // Skeleton header
            Color.sage.opacity(0.2)
                .frame(height: 90)
                .overlay(
                    VStack(alignment: .leading, spacing: 8) {
                        shimmerBlock(width: 36, height: 10)
                        shimmerBlock(width: 180, height: 14)
                        shimmerBlock(width: 120, height: 10)
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 14),
                    alignment: .bottomLeading
                )

            // Skeleton body
            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 6) {
                    shimmerPill(width: 70)
                    shimmerPill(width: 90)
                    shimmerPill(width: 60)
                }

                VStack(alignment: .leading, spacing: 6) {
                    shimmerBlock(width: nil, height: 10)
                    shimmerBlock(width: nil, height: 10)
                    shimmerBlock(width: 200, height: 10)
                }

                HStack(spacing: 8) {
                    shimmerBlock(width: nil, height: 34)
                    shimmerBlock(width: nil, height: 34)
                }
            }
            .padding(12)
            .background(Color.white)
        }
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.05), radius: 12, x: 0, y: 3)
        .opacity(shimmerOn ? 0.45 : 0.8)
        .onAppear {
            withAnimation(.easeInOut(duration: 0.85).repeatForever(autoreverses: true)) {
                shimmerOn = false
            }
        }
    }

    private func shimmerBlock(width: CGFloat?, height: CGFloat) -> some View {
        RoundedRectangle(cornerRadius: 4)
            .fill(Color.mist.opacity(0.7))
            .frame(maxWidth: width.map { $0 } ?? .infinity)
            .frame(height: height)
    }

    private func shimmerPill(width: CGFloat) -> some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(Color.mist.opacity(0.7))
            .frame(width: width, height: 24)
    }
}

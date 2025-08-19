//
//  StarRatingView.swift
//  VisitList
//
//  Created by Thomas Mani on 29/07/25.
//

import SwiftUI

import SwiftUI

struct StarRatingView: View {
    @Binding var rating: Double
    var maximumRating = 5
    var isInteractive = true
    var starSize: CGFloat = 40

    @State private var dragLocation: CGPoint = .zero

    var body: some View {
        HStack(spacing: 6) {
            ForEach(1...maximumRating, id: \.self) { index in
                starImage(for: index)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: starSize, height: starSize)
                    .foregroundColor(.yellow)
                    .scaleEffect(scale(for: index))
                    .animation(.spring(response: 0.3, dampingFraction: 0.5), value: rating)
            }
        }
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { value in
                    guard isInteractive else { return }
                    updateRating(at: value.location.x)
                }
        )
        .frame(height: starSize)
    }

    private func starImage(for index: Int) -> Image {
        if rating > Double(index) - 0.5 {
            return Image(systemName: "star.fill")
        } else if rating > Double(index) - 1 {
            return Image(systemName: "star.leadinghalf.filled")
        } else {
            return Image(systemName: "star")
        }
    }

    private func updateRating(at locationX: CGFloat) {
        let totalWidth = CGFloat(maximumRating) * (starSize + 6)
        let relative = min(max(locationX / totalWidth, 0), 1)
        var newRating = relative * Double(maximumRating) * 2 / 2
        newRating = Double(Int(newRating * 10)) / 10.0
        if newRating != rating {
            rating = newRating
            triggerHaptic()
        }
    }

    private func scale(for index: Int) -> CGFloat {
        return abs(Double(index) - rating) < 1 ? 1.2 : 1.0
    }

    private func triggerHaptic() {
        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.impactOccurred()
    }
}


#Preview {
    @Previewable @State var rating = 0.0
    StarRatingView(rating: $rating)
}

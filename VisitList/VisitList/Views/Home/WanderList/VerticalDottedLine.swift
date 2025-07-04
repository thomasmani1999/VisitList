//
//  VerticalDottedLine.swift
//  VisitList
//
//  Created by Thomas Mani on 02/07/25.
//

import SwiftUI

struct VerticalDottedLine: View {
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                path.move(to: CGPoint(x: geometry.size.width / 2, y: 0))
                path.addLine(to: CGPoint(x: geometry.size.width / 2, y: geometry.size.height))
            }
            .stroke(style: StrokeStyle(lineWidth: 1, dash: [4, 4]))
            .foregroundColor(.gray)
        }
    }
}

#Preview {
    VerticalDottedLine()
}

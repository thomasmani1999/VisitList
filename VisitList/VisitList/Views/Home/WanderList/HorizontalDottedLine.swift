//
//  DottedLine.swift
//  VisitList
//
//  Created by Thomas Mani on 02/07/25.
//

import SwiftUI

struct HorizontalDottedLine: View {
    var body: some View {
        Rectangle()
            .frame(height: 1)
            .foregroundColor(.clear)
            .overlay(
                Rectangle()
                    .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                    .foregroundColor(.gray)
            )
    }
}

#Preview {
    HorizontalDottedLine()
}

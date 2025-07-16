//
//  CustomRoundedRectangle.swift
//  VisitList
//
//  Created by Thomas Mani on 14/07/25.
//

import SwiftUICore
import UIKit

struct RoundedCorners: Shape {
    var radius: CGFloat
    var corners: UIRectCorner

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

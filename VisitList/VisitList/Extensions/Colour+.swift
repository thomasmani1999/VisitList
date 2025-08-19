//
//  Colour+.swift
//  VisitList
//
//  Created by Thomas Mani on 24/06/25.
//

import Foundation
import SwiftUI

extension Color {
    enum app {
        static let primaryBackground = Color("PrimaryBackground")
        static let accent            = Color("Accent")
        static let highlight         = Color("Highlight")
        static let primaryText       = Color("PrimaryText")
        static let secondaryText     = Color("SecondaryText")
    }
    
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        
        let r = Double((rgb >> 16) & 0xFF) / 255
        let g = Double((rgb >> 8) & 0xFF) / 255
        let b = Double(rgb & 0xFF) / 255
        
        self.init(red: r, green: g, blue: b)
    }
}

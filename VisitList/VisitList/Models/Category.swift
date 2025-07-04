//
//  Category.swift
//  VisitList
//
//  Created by Thomas Mani on 28/06/25.
//
import Foundation
import SwiftData

@Model
class Category: Identifiable {
    @Attribute(.unique) var id: UUID
    var name: String
    var icon: String
    var createdAt: Date

    init(name: String, createdAt: Date = .now, icon: String) {
        self.id = UUID()
        self.name = name
        self.createdAt = createdAt
        self.icon = icon
    }
}

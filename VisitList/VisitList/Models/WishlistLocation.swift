//
//  Item.swift
//  VisitList
//
//  Created by Thomas Mani on 24/06/25.
//

import Foundation
import SwiftData
import UIKit

@Model
class WishlistLocation: Identifiable {
    @Attribute(.unique) var id: UUID = UUID.init()
    var title: String
    @Relationship(deleteRule: .nullify) var category: Category
    var thingsToDo: String?
    var lattitude: Double?
    var longitude: Double?
    var createdAt: Date
    var socialMediaContent: String?
    
    init(title: String, category: Category) {
        self.title = title
        self.category = category
        self.createdAt = .now
    }
    
    func setLocation(lattitude: Double, longitude: Double) {
        self.lattitude = lattitude
        self.longitude = longitude
    }
    
    func setThingsToDo(_ things: String) {
        self.thingsToDo = things
    }
    
    func setSocialMediaContent(_ content: String) {
        self.socialMediaContent = content
    }

    func setCategory(_ category: Category) {
        self.category = category
    }
}

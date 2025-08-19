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
class Location: Identifiable {
    @Attribute(.unique) var id: UUID = UUID.init()
    var title: String
    @Relationship(deleteRule: .nullify) var category: Category
    var thingsToDo: String?
    var lattitude: Double?
    var longitude: Double?
    var createdAt: Date
    var socialMediaContent: String?
    var address: String?
    var rating: Double?
    
    init(title: String, category: Category) {
        self.title = title
        self.category = category
        self.createdAt = .now
    }
    
    func setLocation(location: Coordinate?) {
        self.lattitude = location?.latitude
        self.longitude = location?.longitude
    }
    
    func setThingsToDo(_ things: String?) {
        self.thingsToDo = things
    }
    
    func setSocialMediaContent(_ content: String?) {
        self.socialMediaContent = content
    }
    
    func setAddress(_ address: String?) {
        self.address = address
    }
    
    func setRating(_ rating: Double?) {
        self.rating = rating
    }
}

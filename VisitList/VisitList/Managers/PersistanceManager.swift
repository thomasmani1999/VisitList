//
//  PersistanceManager.swift
//  VisitList
//
//  Created by Thomas Mani on 12/07/25.
//
import Foundation
import SwiftData

class PersistanceManager: ObservableObject {
    
    @Published var wishlistedLocations: [WishlistLocation] = []
    @Published var categories: [Category] = []
    private var context: ModelContext?
    
    private func addDefaultCategories() {
        guard let context else { return }
        context.insert(Category(name: "Cafe", icon: "☕️"))
        context.insert(Category(name: "Viewpoint", icon: "🏔️"))
        context.insert(Category(name: "Bookstore", icon: "📚"))
        context.insert(Category(name: "Park", icon: "🌳"))
        context.insert(Category(name: "Shop", icon: "🛍️"))
    }
    
    func fetchCategories() {
        do {
            let descriptor = FetchDescriptor<Category>(
                sortBy: [SortDescriptor(\.name)]
            )
            categories = try context?.fetch(descriptor) ?? []
            
            if categories.isEmpty {
                addDefaultCategories()
                fetchCategories()
            }
        } catch {
            print("Failed to fetch categories: \(error)")
        }
    }
    
    func fetchWishlistedLocations() {
        do {
            let descriptor = FetchDescriptor<WishlistLocation>(
                sortBy: [SortDescriptor(\.createdAt)]
            )
            wishlistedLocations = try context?.fetch(descriptor) ?? []
        } catch {
            print("Failed to fetch locations: \(error)")
        }
    }

    @discardableResult
    func addCategory(name: String, icon: String) -> Category {
        let newCategory = Category(name: name, icon: icon)
        context?.insert(newCategory)
        fetchCategories() // refresh after insertion
        return newCategory
    }
    
    @discardableResult
    func addWishlistedLocation(title: String, category: Category, coordinates: Coordinate, thingsToDo: String?, socialMediaContent: String?, address: String) -> WishlistLocation {
        let newWishlistedLocation = WishlistLocation(title: title, category: category)
        newWishlistedLocation.setLocation(location: coordinates)
        newWishlistedLocation.setThingsToDo(thingsToDo)
        newWishlistedLocation.setSocialMediaContent(socialMediaContent)
        newWishlistedLocation.setAddress(address)
        
        context?.insert(newWishlistedLocation)
        fetchWishlistedLocations()
        return newWishlistedLocation
    }
    
    func deleteWishlistedLocation(_ location: WishlistLocation) {
        let category = location.category
        context?.delete(location)
        fetchWishlistedLocations()
        if !getPresentCategories().contains(category) {
            deleteCategory(category)
        }
    }
    
    func deleteCategory(_ category: Category) {
        context?.delete(category)
        fetchCategories()
    }
    
    func setContext(_ context: ModelContext) {
        self.context = context
        fetchCategories()
        fetchWishlistedLocations()
    }
    
    func getPresentCategories() -> [Category] {
        let presentCategories = wishlistedLocations.compactMap{ $0.category }
        return Array(Set(presentCategories)).sorted { $0.name < $1.name }
    }
}

class MockPersistanceManager: PersistanceManager {
    
    override func fetchWishlistedLocations() {
        wishlistedLocations = [WishlistLocation(title: "Test", category: Category(name: "Test", icon: "😭"))]
    }

    override func addCategory(name: String, icon: String) -> Category {
        var cat = Category(name: "Test new", icon: "😳")
        categories.append(cat)
        return cat
        
    }
    
    @discardableResult
    override func addWishlistedLocation(title: String, category: Category, coordinates: Coordinate, thingsToDo: String?, socialMediaContent: String?, address: String) -> WishlistLocation {
        let newWishlistedLocation = WishlistLocation(title: title, category: category)
        newWishlistedLocation.setLocation(location: coordinates)
        newWishlistedLocation.setThingsToDo(thingsToDo)
        newWishlistedLocation.setSocialMediaContent(socialMediaContent)
        newWishlistedLocation.setAddress(address)
        
        wishlistedLocations.append(newWishlistedLocation)
        return newWishlistedLocation
    }
    
    override func deleteWishlistedLocation(_ location: WishlistLocation) {
        wishlistedLocations.removeAll { loc in
            loc == location
        }
    }
}

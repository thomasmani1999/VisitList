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

    func addCategory(_ category: Category) {
        context?.insert(category)
        fetchCategories() // refresh after insertion
    }
    
    func addWishlistedLocation(_ location: WishlistLocation) {
        context?.insert(location)
        fetchWishlistedLocations()
    }
    
    func deleteWishlistedLocation(_ location: WishlistLocation) {
        context?.delete(location)
        fetchWishlistedLocations()
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
}

class MockPersistanceManager: PersistanceManager {
    
    override func fetchWishlistedLocations() {
        wishlistedLocations = [WishlistLocation(title: "Test", category: Category(name: "Test", icon: "😭"))]
    }

    
    override func addCategory(_ category: Category) {
        let cat = category
        categories.append(cat)
    }
    
    override func addWishlistedLocation(_ location: WishlistLocation) {
        wishlistedLocations.append(location)
    }
    
    override func deleteWishlistedLocation(_ location: WishlistLocation) {
        wishlistedLocations.removeAll { loc in
            loc == location
        }
    }
}

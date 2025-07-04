//
//  WanderListVM.swift
//  VisitList
//
//  Created by Thomas Mani on 28/06/25.
//

import Foundation
import SwiftUI
import SwiftData

class WanderListVM: ObservableObject {
    
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
        do {
            try context.save()
        } catch {
            print("Failed saving default categories")
        }
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

    func addCategory(name: String, icon: String) -> Category {
        let newCategory = Category(name: name, icon: icon)
        context?.insert(newCategory)
        fetchCategories() // refresh after insertion
        return newCategory
    }
    
    func addWishlistedLocation(title: String, category: Category) -> WishlistLocation {
        let newWishlistedLocation = WishlistLocation(title: title, category: category)
        context?.insert(newWishlistedLocation)
        fetchWishlistedLocations()
        return newWishlistedLocation
    }
    
    func deleteWishlistedLocation(_ location: WishlistLocation) {
        context?.delete(location)
        fetchWishlistedLocations()
    }
    
    func setContext(_ context: ModelContext) {
        self.context = context
        fetchCategories()
        fetchWishlistedLocations()
    }
    
    func getPresentCategories() -> [Category] {
        let presentCategories = wishlistedLocations.compactMap{ $0.category }
        return Array(Set(presentCategories))
    }
}

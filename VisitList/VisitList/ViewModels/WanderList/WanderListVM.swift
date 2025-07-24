//
//  WanderListVM.swift
//  VisitList
//
//  Created by Thomas Mani on 28/06/25.
//

import Foundation
import SwiftUI
import Combine

class WanderListVM: ObservableObject {
    
    @Published var fileteredWishlistLocations: [WishlistLocation] = []
    @Published var categories: [Category] = []
    
    private var wishlistedLocations: [WishlistLocation] = []
    private var cancellables = Set<AnyCancellable>()
    private var persistanceManager: PersistanceManager
    public private(set) var selectedFilter: Category?
    
    init(persistanceManager: PersistanceManager) {
        self.persistanceManager = persistanceManager
        persistanceManager.$wishlistedLocations.sink { [weak self] locations in
            self?.wishlistedLocations = locations
            self?.setFilter(self?.selectedFilter)
        }.store(in: &cancellables)
        
        persistanceManager.$categories.sink { [weak self] categories in
            self?.categories = categories
        }.store(in: &cancellables)
    }
    
    func setFilter(_ filter: Category?) {
        selectedFilter = filter
        if let filter {
            fileteredWishlistLocations = wishlistedLocations.filter({ $0.category == filter })
        } else {
            fileteredWishlistLocations = wishlistedLocations
        }
    }
    
    func getPresentCategories() -> [Category] {
        let presentCategories = wishlistedLocations.compactMap{ $0.category }
        return Array(Set(presentCategories)).sorted { $0.name < $1.name }
    }
    
    func deleteWishlistLocation(_ location: WishlistLocation) {
        let category = location.category
        persistanceManager.deleteWishlistedLocation(location)
        if !getPresentCategories().contains(category) {
            deleteCategory(category)
        }
    }
    
    func deleteCategory(_ category: Category) {
        persistanceManager.deleteCategory(category)
    }
    
    @discardableResult
    func addWishlistedLocation(title: String, category: Category, coordinates: Coordinate, thingsToDo: String?, socialMediaContent: String?, address: String) -> WishlistLocation {
        let newWishlistedLocation = WishlistLocation(title: title, category: category)
        newWishlistedLocation.setLocation(location: coordinates)
        newWishlistedLocation.setThingsToDo(thingsToDo)
        newWishlistedLocation.setSocialMediaContent(socialMediaContent)
        newWishlistedLocation.setAddress(address)
        
        persistanceManager.addWishlistedLocation(newWishlistedLocation)
        return newWishlistedLocation
    }
    
    @discardableResult
    func addCategory(name: String, icon: String) -> Category {
        let newCategory = Category(name: name, icon: icon)
        persistanceManager.addCategory(newCategory)
        return newCategory
    }
}

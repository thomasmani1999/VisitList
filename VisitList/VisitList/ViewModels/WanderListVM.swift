//
//  WanderListVM.swift
//  VisitList
//
//  Created by Thomas Mani on 28/06/25.
//

import Foundation
import SwiftUI
import Combine

class WanderListVM: ObservableObject, Filterable {
    
    @Published var fileteredWishlistLocations: [Location] = []
    @Published var categories: [Category] = []
    
    private var wishlistedLocations: [Location] = []
    private var cancellables = Set<AnyCancellable>()
    private var persistanceManager: PersistanceManager
    public private(set) var selectedFilter: Category?
    
    init(persistanceManager: PersistanceManager) {
        self.persistanceManager = persistanceManager
        persistanceManager.$locations.sink { [weak self] locations in
            self?.wishlistedLocations = locations.filter({ $0.rating == nil })
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
    
    func deleteWishlistLocation(_ location: Location) {
        let category = location.category
        persistanceManager.deleteLocation(location)
        if !getPresentCategories().contains(category) {
            deleteCategory(category)
        }
    }
    
    func deleteCategory(_ category: Category) {
        persistanceManager.deleteCategory(category)
    }
    
    @discardableResult
    func addWishlistedLocation(title: String, category: Category, coordinates: Coordinate, thingsToDo: String?, socialMediaContent: String?, address: String) -> Location {
        let newWishlistedLocation = Location(title: title, category: category)
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

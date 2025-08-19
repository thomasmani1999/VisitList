//
//  WentListVM.swift
//  VisitList
//
//  Created by Thomas Mani on 31/07/25.
//

import Foundation
import SwiftUI
import Combine

class WentListVM: ObservableObject, Filterable {
    
    @Published var fileteredWentlistLocations: [Location] = []
    @Published var categories: [Category] = []
    
    private var wentlistedLocations: [Location] = []
    private var cancellables = Set<AnyCancellable>()
    private var persistanceManager: PersistanceManager
    public private(set) var selectedFilter: Category?
    
    init(persistanceManager: PersistanceManager) {
        self.persistanceManager = persistanceManager
        persistanceManager.$locations.sink { [weak self] locations in
            self?.wentlistedLocations = locations.filter({ $0.rating != nil })
            self?.setFilter(self?.selectedFilter)
        }.store(in: &cancellables)
        
        persistanceManager.$categories.sink { [weak self] categories in
            self?.categories = categories
        }.store(in: &cancellables)
    }
    
    func setFilter(_ filter: Category?) {
        selectedFilter = filter
        if let filter {
            fileteredWentlistLocations = wentlistedLocations.filter({ $0.category == filter })
        } else {
            fileteredWentlistLocations = wentlistedLocations
        }
    }
    
    func getPresentCategories() -> [Category] {
        let presentCategories = wentlistedLocations.compactMap{ $0.category }
        return Array(Set(presentCategories)).sorted { $0.name < $1.name }
    }
    
    func deleteWentlistLocation(_ location: Location) {
        let category = location.category
        persistanceManager.deleteLocation(location)
        if !getPresentCategories().contains(category) {
            deleteCategory(category)
        }
    }
    
    func deleteCategory(_ category: Category) {
        persistanceManager.deleteCategory(category)
    }
}

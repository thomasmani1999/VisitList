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
    }
    
    func setFilter(_ filter: Category?) {
        selectedFilter = filter
        if let filter {
            fileteredWishlistLocations = wishlistedLocations.filter({ $0.category == filter })
        } else {
            fileteredWishlistLocations = wishlistedLocations
        }
    }
}

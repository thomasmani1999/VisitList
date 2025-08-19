//
//  LocationViewVM.swift
//  VisitList
//
//  Created by Thomas Mani on 31/07/25.
//

import Foundation
import SwiftUI
import Combine

class LocationViewVM: ObservableObject {
    
    @Published var wishListLocations: [Location] = []

    private var cancellables = Set<AnyCancellable>()
    private var persistanceManager: PersistanceManager
    
    init(persistanceManager: PersistanceManager) {
        self.persistanceManager = persistanceManager
        persistanceManager.$locations.sink { [weak self] locations in
            self?.wishListLocations = locations.filter({ $0.rating == nil })
        }.store(in: &cancellables)
    }
}


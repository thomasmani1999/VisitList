//
//  LocationView.swift
//  VisitList
//
//  Created by Thomas Mani on 31/07/25.
//

import SwiftUI
import MapKit

struct LocationView: View {
    
    @EnvironmentObject private var locationManager: LocationManager
    
    @StateObject var viewModel: LocationViewVM
    
    var body: some View {
        AggregateMapView(selectedLocations: $viewModel.wishListLocations, initialCenter: locationManager.location ?? CLLocationCoordinate2D(latitude: 34.1381, longitude: -118.3534))
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .padding(.horizontal, 20)
        
    }
}

#Preview {
    var persistanceManager = MockPersistanceManager() as PersistanceManager
    LocationView(viewModel: LocationViewVM(persistanceManager: persistanceManager))
        .environmentObject(LocationManager())
        .modelContainer(for: [Category.self, Location.self], inMemory: true)
}

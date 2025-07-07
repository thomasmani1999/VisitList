//
//  LocationPickerView.swift
//  VisitList
//
//  Created by Thomas Mani on 05/07/25.
//
import SwiftUI
import MapKit

struct LocationPickerView: View {
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var locationManager: LocationManager
    
    @State private var isLoading: Bool = false
    @State private var searchText = ""
    @StateObject private var completer = SearchCompleter()
    
    @Binding var userSelectedCoords: Coordinate?
    @Binding var address: String
    
    var body: some View {
        ZStack {
            MapSelectorView(selectedCoordinate: $userSelectedCoords, initialCenter: locationManager.location ?? CLLocationCoordinate2D(latitude: 34.1381, longitude: -118.3534))
                .onChange(of: userSelectedCoords, { oldValue, newValue in
                    if let coord = newValue {
                        isLoading = true
                        locationManager.getLocationName(lattitude: coord.latitude, longitude: coord.longitude, callback: { addr in
                            isLoading = false
                            address = addr
                        })
                    }
                })
                .ignoresSafeArea()
            
            VStack {
                
                if !completer.completions.isEmpty {
                    List(completer.completions, id: \.self) { completion in
                        Button {
                            lookup(completion)
                        } label: {
                            Text(completion.title)
                                .font(.body)
                            Text(completion.subtitle)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .background(.ultraThinMaterial)
                    .cornerRadius(8)
                    .padding(.horizontal)
                    .padding(.top, 60)
                    // limit height so you still see map behind
                    .frame(maxHeight: 200)
                }
                
                Spacer()
                // Coordinate read‑out
                if userSelectedCoords != nil {
                    Text(address)
                        .multilineTextAlignment(.center)
                        .padding(20)
                        .background(.ultraThinMaterial, in: Capsule())
                }
                
                Button {
                    dismiss()
                } label: {
                    Text("Save Location")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(20)
                        .background(userSelectedCoords == nil ? Color.app.secondaryText : Color.app.accent)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .padding(.horizontal)
                }
                .disabled(userSelectedCoords == nil)
            }
            
            if isLoading {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(2)
            }
        }
    }
    
    private func lookup(_ completion: MKLocalSearchCompletion) {
        let req = MKLocalSearch.Request(completion: completion)
        MKLocalSearch(request: req).start { resp, err in
            guard
                let item = resp?.mapItems.first,
                let coord = item.placemark.location?.coordinate
            else { return }
            userSelectedCoords = Coordinate(latitude: coord.latitude, longitude: coord.longitude)
            address = item.placemark.name ?? completion.title
        }
    }
}

#Preview {
    @Previewable @State var coord: Coordinate? = nil
    @Previewable @State var addr: String = " "
    var locationManager = LocationManager()
    LocationPickerView(userSelectedCoords: $coord, address: $addr)
        .environmentObject(locationManager)
}



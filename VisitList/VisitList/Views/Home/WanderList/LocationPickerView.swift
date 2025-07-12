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
    @State private var region: MKCoordinateRegion?
    @StateObject private var completer = SearchCompleter()
    
    @Binding var userSelectedCoords: Coordinate?
    @Binding var address: String
    
    var body: some View {
        ZStack {
            MapSelectorView(selectedCoordinate: $userSelectedCoords, region: $region, initialCenter: locationManager.location ?? CLLocationCoordinate2D(latitude: 34.1381, longitude: -118.3534))
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
                SearchBar(text: $searchText, placeholder: "Search for your location", onCancel: {
                    completer.searchResults = []
                })
                .padding(.top)
                .onChange(of: searchText) { oldValue, newValue in
                    completer.searchAddressesForText(newValue, region: region)
                }
                
                if !completer.searchResults.isEmpty {
                    List(completer.searchResults) { result in
                        VStack(alignment: .leading) {
                            Text(result.title)
                                .font(.system(size: 18, design: .rounded))
                            Text(result.subtitle)
                                .font(.system(size: 12, design: .rounded))
                        }
                        .onTapGesture {
                            if let request = result.searchRequest {
                                isLoading = true
                                completer.getLocations(request: request) { coord in
                                    userSelectedCoords = coord
                                }
                                searchText = ""
                                completer.searchResults = []
                            }
                        }
                    }
                    .contentMargins(.top, 0)
                    .listSectionSpacing(2)
                    .scrollContentBackground(.hidden)
                    .shadow(radius: 5)
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
}

#Preview {
    @Previewable @State var coord: Coordinate? = nil
    @Previewable @State var addr: String = " "
    var locationManager = LocationManager()
    LocationPickerView(userSelectedCoords: $coord, address: $addr)
        .environmentObject(locationManager)
}

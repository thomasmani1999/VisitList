//
//  WanderListDetailView.swift
//  VisitList
//
//  Created by Thomas Mani on 16/07/25.
//

import SwiftUI
import CoreLocation
import MapKit

struct LocationDetailView: View {
    
    @Environment(\.dismiss) private var dismiss
    @State var rating: Double
    
    var location: Location
    var screen: ScreenType
    
    init(location: Location, screenType: ScreenType) {
        self.location = location
        self.screen = screenType
        self.rating = location.rating ?? 0
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .leading)  {
                MeshGradientBackground()
                
                VStack(alignment: .leading){
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 10)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.app.primaryText)
                            .padding(.trailing)
                            .padding(.vertical)
                    }
                    
                    Text(location.title)
                        .font(.system(size: 30, design: .rounded))
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.app.primaryText)
                }
                .padding(.horizontal)
            }
            .clipShape(RoundedRectangle(cornerRadius: 25))
            .ignoresSafeArea(edges: .top)
            .frame(height: 100)
            .shadow(color: Color.app.primaryText.opacity(0.2), radius: 1, x: 0, y: 4)
            .padding(.bottom)
            
            VStack(alignment: .leading) {
                HStack {
                    Text(location.category.name + " " + location.category.icon)
                        .font(.system(size: 15, design: .rounded))
                        .fontWeight(.medium)
                        .foregroundStyle(Color.app.primaryText)
                        .padding(5)
                        .background(Color.app.highlight)
                        .cornerRadius(10)
                        .shadow(color: Color.app.primaryText.opacity(0.2), radius: 1, x: 0, y: 4)
                    
                    Spacer()
                    
                    if let address = location.address, !address.isEmpty {
                        Text("📍 " + address)
                            .font(.system(size: 15, design: .rounded))
                            .fontWeight(.medium)
                            .foregroundColor(Color.app.primaryText)
                            .padding(5)
                            .background(Color.app.highlight)
                            .cornerRadius(10)
                            .shadow(color: Color.app.primaryText.opacity(0.2), radius: 1, x: 0, y: 4)
                    }
                }
                .padding(.bottom, -10)
                
                Text(screen == .wentList ? "Things you did/tried here" : "Things you wanted to do/try here")
                    .font(.system(size: 15, design: .rounded))
                    .fontWeight(.medium)
                    .foregroundStyle(Color.app.primaryText)
                    .padding(.horizontal, 10)
                    .padding(.top, 5)
                    .padding(.bottom, 15)
                    .background(Color.app.accent.opacity(0.6))
                    .clipShape(RoundedCorners(radius: 16, corners: [.topLeft,.topRight]))
                    .offset(y: 20)
                
                TextEditor(text:
                            Binding(
                                get: { location.thingsToDo ?? "" },
                                set: { location.thingsToDo = $0 }
                            )
                )
                .scrollContentBackground(.hidden)
                .background(Color.app.primaryBackground)
                .font(.system(size: 18, design: .rounded))
                .fontWeight(.medium)
                .foregroundStyle(Color.app.primaryText)
                .frame(height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(color: Color.app.primaryText.opacity(0.2), radius: 1, x: 0, y: 4)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.app.accent.opacity(1), lineWidth: 2)
                )
                .padding(.bottom, 10)
                
                if let latitude = location.lattitude, let longitude = location.longitude {
                    ZStack {
                        MapSelectorView(
                            selectedCoordinate: .constant(Coordinate(latitude: latitude, longitude: longitude)),
                            region: .constant(nil),
                            initialCenter: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
                            span: MKCoordinateSpan(latitudeDelta: 0.025, longitudeDelta: 0.025)
                        )
                        .disabled(true)
                        .frame(height: 125)
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                        
                        Color.clear
                            .contentShape(Rectangle())
                            .onTapGesture {
                                showOnMap(latitude: latitude, longitude: longitude)
                            }
                    }
                    .frame(height: 125)
                    .shadow(color: Color.app.primaryText.opacity(0.2), radius: 1, x: 0, y: 4)
                    .padding(.bottom, 10)
                }
                
                HStack {
                    if let urlString = location.socialMediaContent,let url = URL(string: urlString) {
                        Button {
                            UIApplication.shared.open(url)
                        } label: {
                            Text("🎞️ Watch Reel")
                                .font(.system(size: 15, design: .rounded))
                                .foregroundColor(Color.app.accent)
                                .fontWeight(.medium)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 6)
                                .background(
                                    Capsule().fill(Color.app.accent.opacity(0.2))
                                        .shadow(color: Color.app.primaryText.opacity(0.2), radius: 1, x: 0, y: 4)
                                )
                        }
                    }
                    
                    Spacer()
                    
                    if let latitude = location.lattitude, let longitude = location.longitude {
                        Button {
                            navigateTo(latitude: latitude, longitude: longitude)
                        } label: {
                            Text("Navigate 🧭")
                                .font(.system(size: 15, design: .rounded))
                                .foregroundColor(Color.app.accent)
                                .fontWeight(.medium)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 6)
                                .background(
                                    Capsule().fill(Color.app.accent.opacity(0.2))
                                        .shadow(color: Color.app.primaryText.opacity(0.2), radius: 1, x: 0, y: 4)
                                )
                        }
                    }
                }
                
                if screen == .wanderList {
                    Text("Already been?\nGive it a rating!")
                        .font(.system(size: 17, design: .rounded))
                        .foregroundColor(Color.app.primaryText)
                        .fontWeight(.heavy)
                        .padding(.vertical, 6)
                }
                
                HStack {
                    Spacer()
                    StarRatingView(rating: $rating)
                        .onChange(of: rating) { oldValue, newValue in
                            if newValue == 0 {
                                location.setRating(nil)
                            } else {
                                location.setRating(newValue)
                            }
                        }
                    Spacer()
                }
                .padding(.vertical, 12)
                
                if screen == .wanderList {
                    HStack {
                        Spacer()
                        Text("once you rate the location will be moved to the went locations tab")
                            .font(.system(size: 14, design: .rounded))
                            .foregroundColor(Color.app.primaryText)
                            .fontWeight(.heavy)
                            .padding(.vertical, 6)
                            .multilineTextAlignment(.center)
                        Spacer()
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.clear)
        }
        .background {
            Color.app.primaryBackground.ignoresSafeArea()
        }
    }
    
    func navigateTo(latitude: Double, longitude: Double) {
        // Google Maps URL scheme
        let googleMapsURL = URL(string: "comgooglemaps://?daddr=\(latitude),\(longitude)&directionsmode=driving")!
        
        if UIApplication.shared.canOpenURL(googleMapsURL) {
            // Google Maps is installed — open in Google Maps
            UIApplication.shared.open(googleMapsURL, options: [:], completionHandler: nil)
        } else {
            // Fallback to Apple Maps
            let appleMapsURL = URL(string: "http://maps.apple.com/?daddr=\(latitude),\(longitude)&dirflg=d")!
            UIApplication.shared.open(appleMapsURL, options: [:], completionHandler: nil)
        }
    }
    
    func showOnMap(latitude: Double, longitude: Double) {
        // Google Maps URL to show a pin (not directions)
        let googleMapsURL = URL(string: "comgooglemaps://?q=\(latitude),\(longitude)")!
        
        if UIApplication.shared.canOpenURL(googleMapsURL) {
            // Open in Google Maps
            UIApplication.shared.open(googleMapsURL, options: [:], completionHandler: nil)
        } else {
            // Fallback to Apple Maps with pin
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let placemark = MKPlacemark(coordinate: coordinate)
            let mapItem = MKMapItem(placemark: placemark)
            mapItem.name = location.title
            mapItem.openInMaps(launchOptions: nil)
        }
    }
}

#Preview {
    var persistence = MockPersistanceManager() as PersistanceManager
    var vm = WanderListVM(persistanceManager: persistence)
    var cat = vm.addCategory(name: "Cafe", icon: "☕️")
    var location = vm.addWishlistedLocation(title: "Paulettans Pizzeria", category: cat, coordinates: Coordinate(latitude: 0, longitude: 0), thingsToDo: nil, socialMediaContent: nil, address: "")
    
    location.setLocation(location: Coordinate(latitude: 10.516687, longitude: 76.225437))
    location.setThingsToDo("Try out their amazing pizzas")
    location.setSocialMediaContent("https://www.google.com")
    location.setAddress("Thaikaktil house, Vellanikakra")
    return LocationDetailView(location: location, screenType: .wentList)
}

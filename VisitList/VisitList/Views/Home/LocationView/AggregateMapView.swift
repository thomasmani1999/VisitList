//
//  LocationViewMapView.swift
//  VisitList
//
//  Created by Thomas Mani on 31/07/25.
//
import SwiftUI
import MapKit

/// A UIViewRepresentable that provides an MKMapView with tap‑to‑drop‑pin
struct AggregateMapView: UIViewRepresentable {
    // Coordinate the parent owns (nil = no pin yet)
    @Binding var selectedLocations: [Location]
    
    // NEW: where the map should start
    let initialCenter: CLLocationCoordinate2D
    
    // Optional: starting span (default zoom)
    var span: MKCoordinateSpan = .init(latitudeDelta: 0.05, longitudeDelta: 0.05)
    
    // Convenience region builder
    private var startingRegion: MKCoordinateRegion {
        MKCoordinateRegion(center: initialCenter, span: span)
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let config = MKStandardMapConfiguration()
        config.pointOfInterestFilter = .includingAll
        config.elevationStyle = .flat
        
        let map = MKMapView(frame: .zero)
        map.setRegion(startingRegion, animated: false)
        map.showsUserLocation = true
        map.showsCompass = true
        map.showsScale = true
        map.showsUserTrackingButton = true
        map.delegate = context.coordinator
        
        map.preferredConfiguration = config
        return map
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        // Whenever the binding changes externally, refresh the annotation
        uiView.removeAnnotations(uiView.annotations)
        for location in selectedLocations {
            context.coordinator.updatePin(in: uiView, location: location)
        }
    }
    
    func makeCoordinator() -> Coordinator { Coordinator(parent: self) }
    
    // MARK: - Coordinator
    class Coordinator: NSObject, MKMapViewDelegate {
        let parent: AggregateMapView
        init(parent: AggregateMapView) { self.parent = parent }
        
        /// Remove old pin (if any) and add a new one
        func updatePin(in mapView: MKMapView, location: Location) {
            let pin          = MKPointAnnotation()
            if let lat = location.lattitude, let long = location.longitude {
                pin.coordinate   = CLLocationCoordinate2D(latitude: lat, longitude: long)
            }
            pin.title        = location.title
            mapView.addAnnotation(pin)
        }
    }
}

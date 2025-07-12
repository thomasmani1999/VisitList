//
//  MapSelectorView.swift
//  VisitList
//
//  Created by Thomas Mani on 05/07/25.
//

import SwiftUI
import MapKit

/// A UIViewRepresentable that provides an MKMapView with tap‑to‑drop‑pin
struct MapSelectorView: UIViewRepresentable {
    // Coordinate the parent owns (nil = no pin yet)
    @Binding var selectedCoordinate: Coordinate?
    @Binding var region: MKCoordinateRegion?
    
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
        map.showsCompass = false
        map.showsScale = true
        map.showsUserTrackingButton = true
        map.delegate = context.coordinator
        
        map.preferredConfiguration = config
        
        // Single‑tap gesture recogniser
        let tap = UITapGestureRecognizer(target: context.coordinator,
                                         action: #selector(Coordinator.handleTap(_:)))
        map.addGestureRecognizer(tap)
        return map
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        // Whenever the binding changes externally, refresh the annotation
        if let selectedCoordinate {
            context.coordinator.updatePin(in: uiView, coordinate: CLLocationCoordinate2D(latitude: selectedCoordinate.latitude, longitude: selectedCoordinate.longitude))
        }
    }
    
    func makeCoordinator() -> Coordinator { Coordinator(parent: self) }
    
    // MARK: - Coordinator
    class Coordinator: NSObject, MKMapViewDelegate {
        let parent: MapSelectorView
        init(parent: MapSelectorView) { self.parent = parent }
        
        // Handle tap, convert to map coordinate, drop / move the pin
        @objc func handleTap(_ gesture: UITapGestureRecognizer) {
            guard let mapView = gesture.view as? MKMapView else { return }
            let location = gesture.location(in: mapView)
            let coord   = mapView.convert(location, toCoordinateFrom: mapView)
            parent.selectedCoordinate = Coordinate(latitude: coord.latitude, longitude: coord.longitude)
            updatePin(in: mapView, coordinate: coord)  // update annotation
        }
        
        /// Remove old pin (if any) and add a new one
        func updatePin(in mapView: MKMapView, coordinate: CLLocationCoordinate2D?) {
            mapView.removeAnnotations(mapView.annotations)
            if let coord = coordinate {
                let pin          = MKPointAnnotation()
                pin.coordinate   = coord
                mapView.addAnnotation(pin)
                mapView.setCenter(coord, animated: true)
            }
        }
        
        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            parent.region = mapView.region
        }
    }
}

class SearchCompleter: NSObject, ObservableObject {
    
    @Published var searchResults: [SearchResult] = []
    
    private var completer = MKLocalSearchCompleter()
    
    func searchAddressesForText(_ text: String, region: MKCoordinateRegion?) {
        completer.delegate = self
        if let region {
            completer.region = region
        }
        completer.queryFragment = text
    }
    
    func getLocations(request: MKLocalSearch.Request, completion: @escaping (Coordinate) -> Void) {
        let search = MKLocalSearch(request: request)
        search.start
        {
            (response, error) in
            guard let response = response else { return }
        
            let item = response.mapItems.first
            
            if let coordinate = item?.placemark.coordinate {
                completion(Coordinate(latitude: coordinate.latitude, longitude: coordinate.longitude))
            }
        }
    }
}

extension SearchCompleter: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results.compactMap { result in
            let street = result.title
            let subtitle = result.subtitle
            let searchRequest = MKLocalSearch.Request(completion: result)
            return SearchResult(title: street, subtitle: subtitle, searchRequest: searchRequest)
        }
    }
}

//
//  Untitled.swift
//  VisitList
//
//  Created by Thomas Mani on 10/07/25.
//
import Foundation
import MapKit

extension MKCoordinateRegion: Equatable {
    public static func == (lhs: MKCoordinateRegion, rhs: MKCoordinateRegion) -> Bool {
        return lhs.center == rhs.center && lhs.span.longitudeDelta == rhs.span.longitudeDelta && lhs.span.latitudeDelta == rhs.span.latitudeDelta
    }
}

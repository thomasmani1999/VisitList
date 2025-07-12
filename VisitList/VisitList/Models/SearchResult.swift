//
//  SearchResult.swift
//  VisitList
//
//  Created by Thomas Mani on 11/07/25.
//
import Foundation
import MapKit

struct SearchResult: Identifiable, Hashable {
    let id = UUID()
    var title: String
    var subtitle: String
    var searchRequest: MKLocalSearch.Request?
}

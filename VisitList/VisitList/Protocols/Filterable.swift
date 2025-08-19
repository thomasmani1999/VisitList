//
//  Filterable.swift
//  VisitList
//
//  Created by Thomas Mani on 31/07/25.
//

import Foundation

protocol Filterable: ObservableObject {
    var selectedFilter: Category? { get }
    
    func setFilter(_ filter: Category?)
    func getPresentCategories() -> [Category]
}

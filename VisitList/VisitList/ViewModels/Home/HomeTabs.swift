//
//  HomeTabs.swift
//  VisitList
//
//  Created by Thomas Mani on 28/06/25.
//

import Foundation

enum TabbedItems: Int, CaseIterable {
    
    case home = 0
    case wanderList = 1
    case wentList = 2
    
    var title: String {
        switch self {
        case .home:
            return "Home"
        case .wanderList:
            return "Wander List"
        case .wentList:
            return "Went List"
        }
    }
    
    var iconName: String {
        switch self {
        case.home:
            return "location.fill"
        case .wanderList:
            return "heart.fill"
        case .wentList:
            return "star.fill"
        }
    }
}

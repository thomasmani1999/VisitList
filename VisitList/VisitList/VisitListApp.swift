//
//  VisitListApp.swift
//  VisitList
//
//  Created by Thomas Mani on 24/06/25.
//

import SwiftUI
import SwiftData

@main
struct VisitListApp: App {
    
    @AppStorage("isLoggedin") var isLoggedIn: Bool = false

    var body: some Scene {
        WindowGroup {
            if isLoggedIn {
                HomeView()
            } else {
                OnboardingView()
            }
        }
        .modelContainer(for: [Category.self, WishlistLocation.self], inMemory: true)
    }
}

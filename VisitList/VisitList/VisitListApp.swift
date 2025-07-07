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
    @StateObject private var locationManager = LocationManager()
    
    let container: ModelContainer = {
        do {
            let container = try ModelContainer(for: Category.self, WishlistLocation.self)
            return container
        } catch {
            fatalError("❌ Failed to create container: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            if isLoggedIn {
                HomeView()
            } else {
                OnboardingView()
            }
        }
        .modelContainer(container)
        .environmentObject(locationManager)
    }
}

//
//  HomeViewModel.swift
//  VisitList
//
//  Created by Thomas Mani on 28/06/25.
//

import SwiftUI

class HomeVM: ObservableObject {
    
    @AppStorage("username") private var name: String = ""
    @Published var selectedTab = 0
    
    func getUsername() -> String {
        return name
    }
    
}

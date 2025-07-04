//
//  OnboardingViewModel.swift
//  VisitList
//
//  Created by Thomas Mani on 28/06/25.
//

import SwiftUI

class OnboardingVM: ObservableObject {
    
    //MARK: AppStorage
    @AppStorage("username") var name: String = ""
    @AppStorage("isLoggedin") var isLoggedIn: Bool = false
    
}

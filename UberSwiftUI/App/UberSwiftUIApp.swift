//
//  UberSwiftUIApp.swift
//  UberSwiftUI
//
//  Created by Maciej on 11/10/2022.
//

import SwiftUI

@main
struct UberSwiftUIApp: App {
    @StateObject var locationViewModel = LocationSearchViewModel()
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(locationViewModel)
        }
    }
}

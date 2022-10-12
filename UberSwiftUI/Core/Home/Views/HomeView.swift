//
//  HomeView.swift
//  UberSwiftUI
//
//  Created by Maciej on 11/10/2022.
//

import SwiftUI

struct HomeView: View {
    //    @State private var showLocationSearchView = false
    @State private var mapState = MapViewState.noInput
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ZStack(alignment: .top) {
                UberMapViewRepresentable(mapState: $mapState)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    MapViewActionButton(mapState: $mapState)
                        .background(mapState == .searchngForLocation ? .white : .white.opacity(0.0))
                    
                    if mapState == .searchngForLocation {
                        LocationSearchView(mapState: $mapState)
                    } else if mapState == .noInput {
                        LocationSearchActivationView()
                            .onTapGesture {
                                withAnimation(.spring()) {
                                    mapState = .searchngForLocation
                                }
                            }
                    }
                }
            }
            
            if mapState == .locationSelected {
                RideRequestView()
                    .transition(.move(edge: .bottom))
            }
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(LocationSearchViewModel())
    }
}

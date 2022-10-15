//
//  MapViewActionButton.swift
//  UberSwiftUI
//
//  Created by Maciej on 12/10/2022.
//

import SwiftUI

struct MapViewActionButton: View {
    @Binding var mapState: MapViewState
    @EnvironmentObject var locationViewModel: LocationSearchViewModel
    
    var body: some View {
        Button {
            withAnimation(.spring()) {
                actionForState(mapState)
            }
        } label: {
            Image(systemName: imageNameForState(mapState))
                .resizable()
                .scaledToFit()
                .frame(width: 25, height: 25)
                .padding()
                .foregroundColor(.black)
                .background(.white)
                .clipShape(Circle())
                .shadow(color: .black.opacity(0.5), radius: 6)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
    }
    
    func actionForState(_ state: MapViewState) {
        switch state {
        case .noInput:
            print("DEBUG: No input")
        case .searchngForLocation:
            mapState = .noInput
        case .locationSelected, .polylineAdded:
            mapState = .noInput
            locationViewModel.selectedUberLocation = nil
        }
    }
    
    func imageNameForState(_ state: MapViewState) -> String {
        switch state {
        case .noInput:
            return "line.3.horizontal"
        case .searchngForLocation, .locationSelected:
            return "arrow.left"
        default:
            return "arrow.left"
        }
    }
}

struct MapViewActionButton_Previews: PreviewProvider {
    static var previews: some View {
        MapViewActionButton(mapState: .constant(.noInput))
    }
}

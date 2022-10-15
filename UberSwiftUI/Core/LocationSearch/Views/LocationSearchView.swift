//
//  LocationSearchView.swift
//  UberSwiftUI
//
//  Created by Maciej on 12/10/2022.
//

import SwiftUI

struct LocationSearchView: View {
    @EnvironmentObject var locationViewModel: LocationSearchViewModel
    @State private var startLocationText = ""
    @Binding var mapState: MapViewState
    
    var body: some View {
        VStack {
            HStack {
                VStack {
                    Circle()
                        .fill(Color(.systemGray3))
                        .frame(width: 6, height: 6)
                    
                    Rectangle()
                        .fill(Color(.systemGray3))
                        .frame(width: 2, height: 32)
                    
                    Rectangle()
                        .fill(Color.theme.primaryTextColor)
                        .frame(width: 6, height: 6)
                }
                
                VStack {
                    Text("Current Location")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.gray)
                        .padding(8)
                        .background(Color(.systemGroupedBackground))
                        .cornerRadius(10)
                    
                    TextField("Where to?", text: $locationViewModel.queryFragment)
                        .padding(8)
                        .background(Color(.systemGray4))
                        .cornerRadius(10)
                }
            }
            .padding(.horizontal)
            
            Divider()
                .padding(.vertical)
        
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(locationViewModel.results, id: \.self) { result in
                        LocationSearchResultCell(title: result.title, subtitle: result.subtitle)
                            .onTapGesture {
                                withAnimation(.spring()) {
                                    locationViewModel.selectLocation(result)
                                    mapState = .locationSelected
                                }
                            }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.theme.backgroundColor)
    }
}

struct LocationSearchView_Previews: PreviewProvider {
    static var previews: some View {
        LocationSearchView(mapState: .constant(.searchngForLocation))
            .environmentObject(LocationSearchViewModel())
    }
}

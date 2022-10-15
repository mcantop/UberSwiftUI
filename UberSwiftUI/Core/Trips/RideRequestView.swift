//
//  RideRequestView.swift
//  UberSwiftUI
//
//  Created by Maciej on 13/10/2022.
//

import SwiftUI

struct RideRequestView: View {
    @State private var selectedRideType: RideType = .uberX
    @EnvironmentObject var locationViewModel: LocationSearchViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            Capsule()
                .foregroundColor(Color(.systemGray5))
                .frame(width: 48, height: 6)
                .padding(.top, 8)
            
            VStack(spacing: 6) {
                HStack {
                    Circle()
                        .fill(Color(.systemGray3))
                        .frame(width: 8, height: 8)
                    
                    Text("Current location")
                        .font(.headline)
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Text(locationViewModel.pickupTime ?? "1:30 PM")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.gray)
                }
                
                HStack {
                    Rectangle()
                        .fill(Color(.systemGray3))
                        .frame(width: 2, height: 32)
                        .padding(.trailing, 3)
                    
                    Text("\(String(format: "%.2f", locationViewModel.calculateDistanceInKm())) km")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Text(locationViewModel.tripTime ?? "about 15 minutes")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.gray)
                }
                .padding(.leading, 3)
                
                HStack {
                    Rectangle()
                        .fill(.black)
                        .frame(width: 8, height: 8)
                    
                    Text(locationViewModel.selectedUberLocation?.title ?? "Location Title")
                            .font(.headline)
                    
                    Spacer()
                    
                    Text(locationViewModel.dropoffTime ?? "1:45 PM")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }
            }
            .padding(.horizontal)
            
            Divider()
            
            Text("Suggested rides".uppercased())
                .font(.headline)
                .padding(.horizontal)
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(RideType.allCases) { rideType in
                        VStack(spacing: 8) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(rideType.description)
                                    .font(.headline)
                                    .foregroundColor(rideType == selectedRideType ? .white : Color.theme.primaryTextColor)
                                
                                Text(locationViewModel.computeRidePrice(forType: rideType).toCurrency())
                                    .font(.caption)
                                    .foregroundColor(rideType == selectedRideType ? .white.opacity(0.75) : Color.theme.primaryTextColor.opacity(0.75))
                            }
                            
                            Image(rideType.imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 75, height: 50)
                        }
                        .padding()
                        .frame(width: 150, height: 130)
                        .foregroundColor(rideType == selectedRideType ? .white : .black)
                        .background(rideType == selectedRideType ? .blue : Color.theme.secondaryBackgroundColor)
                        .scaleEffect(rideType == selectedRideType ? 1.2 : 1.0)
                        .cornerRadius(10)
                        .onTapGesture {
                            withAnimation(.spring()) {
                                selectedRideType = rideType
                            }
                        }
                    }
                }
            }
            .padding(.horizontal)
            
            Divider()
            
            HStack(spacing: 6) {
                Text("Visa")
                    .font(.headline)
                    .padding(6)
                    .background(.blue)
                    .cornerRadius(4)
                    .foregroundColor(.white)
                    .padding(.leading, 8)
                
                Text("**** 1234")
                    .fontWeight(.bold)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .imageScale(.medium)
                    .padding()
                
            }
            .frame(height: 50)
            .background(Color.theme.secondaryBackgroundColor)
            .cornerRadius(10)
            .padding(.horizontal)
            
            Button {
                
            } label: {
                Text("Confirm ride".uppercased())
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(height: 50)
            }
            .frame(maxWidth: .infinity)
            .background(Color(.systemBlue))
            .cornerRadius(10)
            .padding(.horizontal)
        }
        .padding(.bottom, 32)
        .background(Color.theme.backgroundColor)
        .cornerRadius(32)
    }
}

struct RideRequestView_Previews: PreviewProvider {
    static var previews: some View {
        RideRequestView()
            .environmentObject(LocationSearchViewModel())
    }
}

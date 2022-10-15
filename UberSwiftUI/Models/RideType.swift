//
//  RideType.swift
//  UberSwiftUI
//
//  Created by Maciej on 13/10/2022.
//

import Foundation

enum RideType: Int, CaseIterable, Identifiable {
case uberX
case uberBlack
case uberTesla
    
    var id: Int { return rawValue }
    
    var description: String {
        switch self {
        case .uberX: return "Uber X"
        case .uberBlack: return "Uber Black"
        case .uberTesla: return "Uber Tesla"
        }
    }
    
    var imageName: String {
        switch self {
        case .uberX: return "uber-x"
        case .uberBlack: return "uber-black"
        case .uberTesla: return "uber-tesla"
        }
    }
    
    var baseFare: Double {
        switch self {
        case .uberX: return 5
        case .uberBlack: return 10
        case .uberTesla: return 15
        }
    }
    
    func computePrice(for distanceInMeters: Double) -> Double {
        let distanceInKm = distanceInMeters / 1000
        
        switch self {
        case .uberX: return distanceInKm * 1.5 + baseFare
        case .uberBlack: return distanceInKm * 1.75 + baseFare
        case .uberTesla: return distanceInKm * 2.0 + baseFare
        }
    }
}

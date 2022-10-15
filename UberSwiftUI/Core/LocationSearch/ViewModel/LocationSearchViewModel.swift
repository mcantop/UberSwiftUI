//
//  LocationSearchViewModel.swift
//  UberSwiftUI
//
//  Created by Maciej on 13/10/2022.
//

import Foundation
import MapKit

final class LocationSearchViewModel: NSObject, ObservableObject {
    // MARK: - Properties
    @Published var results = [MKLocalSearchCompletion]()
    @Published var selectedUberLocation: UberLocation?
    @Published var pickupTime: String?
    @Published var dropoffTime: String?
    @Published var tripTime: String?
    
    private let searchCompleter = MKLocalSearchCompleter()
    var queryFragment = "" {
        didSet {
            searchCompleter.queryFragment = queryFragment
        }
    }
    
    var region: MKCoordinateRegion?
    var userLocation: CLLocationCoordinate2D?
    
    // MARK: - Lifecycle
    override init() {
        super.init()
        searchCompleter.delegate = self
        searchCompleter.resultTypes = [.pointOfInterest]
        searchCompleter.queryFragment = queryFragment
    }
    
    // MARK: - Helpers
    
    func selectLocation(_ localSearch: MKLocalSearchCompletion) {
        locationSearch(forLocalSearchCompletion: localSearch) { response, error in
            if let error = error {
                print(error.localizedDescription)
                return
                // return because we don't want to further execute the broken func
            }
            
            guard let item = response?.mapItems.first else { return }
            
            let coordinate = item.placemark.coordinate
            
            self.selectedUberLocation = UberLocation(title: localSearch.title, coordinate: coordinate)
        }
    }
    
    func locationSearch(forLocalSearchCompletion localSearch: MKLocalSearchCompletion, completion: @escaping MKLocalSearch.CompletionHandler) {
        let searchRequest = MKLocalSearch.Request()
        if let region = region {
            print(region)
            searchRequest.region = region
        }
        searchRequest.naturalLanguageQuery = localSearch.title.appending(localSearch.subtitle)
        searchRequest.pointOfInterestFilter = .excludingAll

        
        let search = MKLocalSearch(request: searchRequest)
        search.start(completionHandler: completion)
    }
    
    func computeRidePrice(forType type: RideType) -> Double {
        guard let destinationCoordinate = selectedUberLocation?.coordinate else { return 0.0 }
        guard let userCoordinate = self.userLocation else { return 0.0}
        
        let userLocation = CLLocation(latitude: userCoordinate.latitude, longitude: userCoordinate.longitude)
        let destination = CLLocation(latitude: destinationCoordinate.latitude, longitude: destinationCoordinate.longitude)
        
        let distance = userLocation.distance(from: destination)
        
        return type.computePrice(for: distance)
    }
    
    func calculateDistanceInKm() -> Double {
        guard let destinationCoordinate = selectedUberLocation?.coordinate else { return 0.0 }
        guard let userCoordinate = self.userLocation else { return 0.0 }
        
        let userLocation = CLLocation(latitude: userCoordinate.latitude, longitude: userCoordinate.longitude)
        let destination = CLLocation(latitude: destinationCoordinate.latitude, longitude: destinationCoordinate.longitude)
            
        return userLocation.distance(from: destination) / 1000
    }
    
    func getDestinationRoute(from userLocation: CLLocationCoordinate2D,
                             to destination: CLLocationCoordinate2D,
                             completion: @escaping(MKRoute) -> Void) {
        let userPlacemark = MKPlacemark(coordinate: userLocation)
        let destinationPlacemark = MKPlacemark(coordinate: destination)
        let request = MKDirections.Request()
        
        request.source = MKMapItem(placemark: userPlacemark)
        request.destination = MKMapItem(placemark: destinationPlacemark)
        
        let directions = MKDirections(request: request)
        
        directions.calculate { response, error in
            if let error = error {
                print("DEBUG: Failed to get directions with error: \(error.localizedDescription)")
            }
            
            // Route type, usually the first one is the fastest.
            guard let route = response?.routes.first else { return }
            self.configureTimes(with: route.expectedTravelTime)
            completion(route)
        }
    }
    
    func configureTimes(with expectedTravelTime: Double) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        
        let pickupTimeDate = Date()
        let dropoffTimeDate = Date() + expectedTravelTime
        
        let tripTimeDate = dropoffTimeDate.timeIntervalSince(pickupTimeDate)
        let tripTimeDateInt = Int(tripTimeDate.rounded(.up))
        let tripTimeMinutes = "about \((tripTimeDateInt % 3600) / 60) minutes"
                
        pickupTime = dateFormatter.string(from: pickupTimeDate)
        dropoffTime = dateFormatter.string(from: dropoffTimeDate)
        tripTime = tripTimeMinutes
    }
}


// MARK: - MKLocalSearchCompleterDelegate
extension LocationSearchViewModel: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.results = completer.results
    }
}

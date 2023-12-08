//
//  LocationSearchService.swift
//  TestBackgroundModelContext
//
//  Created by Nick Selvitelli on 11/26/23.
//

import MapKit

struct SearchCompletions: Identifiable {
    let id = UUID()
    let title: String
    let subTitle: String
    let mapItem: MKMapItem
}

@Observable
class LocationSearchService: NSObject, MKLocalSearchCompleterDelegate {
    private let completer: MKLocalSearchCompleter

    var completions: [SearchCompletions] = [SearchCompletions]()
    
    
    private var searchFragment : String = ""

    init(completer: MKLocalSearchCompleter) {
        self.completer = completer
        super.init()
        self.completer.delegate = self
    }

    func update(queryFragment: String) {
        completer.resultTypes = .pointOfInterest
        completer.queryFragment = queryFragment
        self.searchFragment = queryFragment
    }
    
    func clearResults() {
        completions = []
    }

    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        completions = completer.results.compactMap {
            
            if let mapItem = $0.value(forKey: "_mapItem") as? MKMapItem {
                
                var subtitle = $0.subtitle
                
                if subtitle.isEmpty {
                    subtitle = "(lat: \(mapItem.placemark.coordinate.latitude), long: \(mapItem.placemark.coordinate.longitude))"
                }
                
                return SearchCompletions(title: $0.title,
                                         subTitle: subtitle,
                                         mapItem: mapItem)
            }
            return nil
        }
        
        if completions.isEmpty {
            hardSearch()
        }
    }
    
    func hardSearch() {
        let request = MKLocalSearch.Request()
        
        request.naturalLanguageQuery = self.searchFragment
        
        Task {
            let response = try await MKLocalSearch(request: request).start()
            
            completions = response.mapItems.map { mapItem in
                
                let title = mapItem.name ?? "Unknown"
                
                let coordString = "(lat: \(mapItem.placemark.coordinate.latitude), long: \(mapItem.placemark.coordinate.longitude))"
                let subtitle = mapItem.placemark.title ?? coordString
                
                return SearchCompletions(title: title,
                                         subTitle: subtitle,
                                         mapItem: mapItem)
            }
        }
    }
}

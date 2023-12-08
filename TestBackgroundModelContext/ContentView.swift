//
//  ContentView.swift
//  TestBackgroundModelContext
//
//  Created by Nick Selvitelli on 11/8/23.
//

import SwiftUI
import MapKit
import SwiftData

struct ContentView: View {
    
    @Environment(\.modelContext) var modelContext
    @ObservedObject var background = BackgroundSingleton.shared
    
    @AppStorage("mapLineColor") var mapLineColor = Color.blue
    @AppStorage("showPointsOnMap") var showPointsOnMap = false
    @AppStorage("pointColor") var pointColor = Color.white
    @AppStorage("pointSize") var pointSize = 50.0
    @AppStorage("showPlacesOnMap") var showPlacesOnMap = false
    @AppStorage("placeColor") var placeColor = Color.red
    
    @Query var places : [PlaylistLocation]
    
    @State private var search = ""
        
    var body: some View {
        NavigationStack {
            Map {
                
                if !background.points.isEmpty {
                    MapPolyline(coordinates: background.points, contourStyle: .geodesic)
                        .stroke(mapLineColor, lineWidth: 5)
                }
                
                if showPointsOnMap {
                    ForEach(background.points, id: \.self) { point in
                        MapCircle(center: point, radius: pointSize)
                            .foregroundStyle(pointColor)
                    }
                }
                
                if showPlacesOnMap {
                    ForEach(places) { place in
                        Marker(place.name, coordinate: CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude))
                            .tint(placeColor)
                    }
                }
                
                                
                UserAnnotation()
            }
            .colorScheme(.dark)
            .mapControls {
                MapUserLocationButton()
                MapCompass()
            }
            .overlay(alignment: .bottom) {
                HStack(alignment: .lastTextBaseline) {
                    Spacer()
                    
                    MapMenu()
                }
            }
            .task {
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        print("All set!")
                    } else if let error = error {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
}


extension CLLocationCoordinate2D: Hashable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(latitude)
        hasher.combine(longitude)
    }
}


#Preview {
    ContentView()
}

//
//  Settings.swift
//  TestBackgroundModelContext
//
//  Created by Nick Selvitelli on 11/13/23.
//

import SwiftUI



struct Settings : View {
    
    // MAP
    @AppStorage("mapLineColor") var mapLineColor = Color.blue
    
    @AppStorage("showPointsOnMap") var showPointsOnMap = false
    @AppStorage("pointColor") var pointColor = Color.white
    @AppStorage("pointSize") var pointSize = 50.0
    
    @AppStorage("showPlacesOnMap") var showPlacesOnMap = false
    @AppStorage("placeColor") var placeColor = Color.red
    
    
    // DISPLAY
    @AppStorage("sliderBackgroundColor") var sliderBackgroundColor = Color.green.opacity(0.5)
    @AppStorage("sliderProgressColor") var sliderProgressColor = Color.green
    
    
    // BACKGROUND
    @AppStorage("pinTrackingDistanceMeters") var pinTrackingDistanceMeters = 1000.0
    @AppStorage("visitedRangeMeters") var visitedRangeMeters = 1000.0
    
    
    
    @State private var isPresentingConfirm: Bool = false
    
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    var body: some View {
        Form {
            Section("Map") {
                ColorPicker("Map Line Color",
                            selection: $mapLineColor,
                            supportsOpacity: false)
                
                Toggle("Show Travel Points", isOn: $showPointsOnMap)
                
                if showPointsOnMap {
                    ColorPicker("Travel Point Color",
                                selection: $pointColor,
                                supportsOpacity: false)
                    HStack {
                        Text("Point Size").padding(.trailing, 20)
                        Slider(value: $pointSize, in: 10...200, step: 10.0)
                        Text("\(Int(pointSize))")
                    }
                }
                
                Toggle("Show Place Markers", isOn: $showPlacesOnMap)
                
                if showPlacesOnMap {
                    ColorPicker("Place Marker Color",
                                selection: $placeColor,
                                supportsOpacity: false)
                }
            }
            
            Section("Playlists") {
                ColorPicker("Slider Background Color",
                            selection: $sliderBackgroundColor,
                            supportsOpacity: false)
                ColorPicker("Slider Progress Color",
                            selection: $sliderProgressColor,
                            supportsOpacity: false)
            }
            
            Section("Tracking Distances (in meters)") {
                HStack {
                    Text("Distance Between Pins")
                    Spacer()
                    TextField("Distance", value: $pinTrackingDistanceMeters, formatter: formatter)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 75)
                }
                
                HStack {
                    Text("Minimum Distance Between Visited Places and Pins")
                    Spacer()
                    TextField("Distance", value: $visitedRangeMeters, formatter: formatter)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 75)
                }
                
            }
            
            
            // RESET
            Button() {
                isPresentingConfirm = true
            } label: {
                Label("Reset Settings", systemImage: "trash.fill")
                    .foregroundStyle(.red)
            }
            .confirmationDialog("Reset all settings?", isPresented: $isPresentingConfirm) {
                Button("Reset", role: .destructive) {
                    let domain = Bundle.main.bundleIdentifier!
                    UserDefaults.standard.removePersistentDomain(forName: domain)
                    UserDefaults.standard.synchronize()
                }
            }
        }
    }
}


#Preview {
    Settings()
}

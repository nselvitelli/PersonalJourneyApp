//
//  PlaylistForm.swift
//  TestBackgroundModelContext
//
//  Created by Nick Selvitelli on 11/14/23.
//

import SwiftUI
import MapKit

struct PlaylistForm : View {
    
    @Environment(\.dismiss) var dismiss
    
    @State var present = false
    @State var selectedLocation : MKMapItem?
    
    @Bindable var playlist : Playlist
    
    var body: some View {
        Form {
            
            Section {
                TextField("Playlist Name", text: $playlist.name)
                    .autocorrectionDisabled()
            }
            
            
            Section("Places") {
                List {
                    Button("Add Location") {
                        present.toggle()
                    }
                    
                    ForEach(playlist.places) { place in
                        
                        HStack {
                            
                            if BackgroundSingleton.shared.hasVisited(latitude: place.latitude, longitude: place.longitude) {
                                Image(systemName: "checkmark.square")
                            }
                            else {
                                Image(systemName: "square")
                            }
                            
                            VStack {
                                Text("\(place.name)")
                                    .bold()
                                Text("(\(place.latitude), \(place.longitude))")
                            }
                        }
                        .swipeActions {
                            Button(role: .destructive) {
                                playlist.places.removeAll(where: { other in return other.id == place.id})
                            } label: {
                                Label("Delete", systemImage: "trash.fill")
                            }
                        }
                    }
                }
            }
            
            
            HStack {
                Button("Done") {
                    dismiss()
                }
                .buttonStyle(.bordered)
                .disabled(playlist.name.isEmpty)
            }
        }
        .sheet(isPresented: $present) {
            SearchLocationView(selectedPlace: $selectedLocation, isPresented: $present)
        }
        .onChange(of: selectedLocation) { old, new in
            if let mapItem = selectedLocation {
                if let loc = mapItem.placemark.location {
                    let name = mapItem.name ?? ""
                    let lat = loc.coordinate.latitude
                    let long = loc.coordinate.longitude
                    
                    playlist.places.append(PlaylistLocation(name: name, latitude: lat, longitude: long))
                }
            }
            
        }
    }
}

//
//  PlaylistLocation.swift
//  TestBackgroundModelContext
//
//  Created by Nick Selvitelli on 11/22/23.
//

import SwiftData
import Foundation


@Model
class PlaylistLocation {
    
    let id: UUID = UUID()
    let name : String
    let latitude : Double
    let longitude : Double
    
    init(name: String, latitude: Double, longitude: Double) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
    }
}



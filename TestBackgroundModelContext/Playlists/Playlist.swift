//
//  Playlist.swift
//  TestBackgroundModelContext
//
//  Created by Nick Selvitelli on 11/14/23.
//

import SwiftUI
import SwiftData

@Model
class Playlist {
    
    var name : String
    @Relationship(deleteRule: .cascade) var places : [PlaylistLocation]
    
    init(name: String = "", places: [PlaylistLocation] = []) {
        self.name = name
        self.places = places
    }
    
}

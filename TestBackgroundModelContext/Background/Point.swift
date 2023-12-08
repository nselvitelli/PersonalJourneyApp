//
//  Point.swift
//  TestBackgroundModelContext
//
//  Created by Nick Selvitelli on 11/8/23.
//

import Foundation
import SwiftData

@Model
class Point {
    
    let longitude : Double
    let latitude: Double
    let date: Date
    
    init(longitude: Double, latitude: Double, date: Date = .now) {
        self.date = date
        self.longitude = longitude
        self.latitude = latitude
    }
}

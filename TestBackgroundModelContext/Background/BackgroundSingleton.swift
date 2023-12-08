//
//  BackgroundSingleton.swift
//  TestBackgroundModelContext
//
//  Created by Nick Selvitelli on 11/8/23.
//

import SwiftUI
import CoreLocation
import SwiftData

enum StaticData {
    static let monitorName = "PointMonitor"
    static let regionName = "region"
}

@MainActor
class BackgroundSingleton: ObservableObject {
    
    @AppStorage("pinTrackingDistanceMeters") var pinTrackingDistanceMeters = 1000.0
    @AppStorage("visitedRangeMeters") var visitedRangeMeters = 1000.0
    
    @Published public var points : [CLLocationCoordinate2D]
    
    private let manager: CLLocationManager
    private let delegate: LocationManagerDelegate
    
    private var context: ModelContext
    public var container: ModelContainer
    
    public var monitor: CLMonitor?
    
    private var continueTrackingRegions : Bool = true
    public var dateFilter : DateFilter = .Off
    
    static var shared: BackgroundSingleton = {
        let instance = BackgroundSingleton()
        // ... configure the instance
        instance.startMonitoringConditions()
        // ...
        return instance
    }()
    
    
    init() {
        self.manager = CLLocationManager()
        self.delegate = LocationManagerDelegate()
        self.manager.delegate = delegate
        self.manager.allowsBackgroundLocationUpdates = true
        self.manager.showsBackgroundLocationIndicator = true
        
        self.container = try! ModelContainer(for: Point.self, Playlist.self, PlaylistLocation.self)
        self.context = ModelContext(container)
        self.context.autosaveEnabled = true
        
        self.points = []
        self.updatePoints()
    }
    
    func startMonitoringConditions() {
        print("Observable Monitor Model online.")
        Task {
            monitor = await CLMonitor(StaticData.monitorName)
            
            if let identifiers = await monitor?.identifiers {
                
                print(identifiers)
                
                
                if identifiers.count == 0 {
                    
                    if let coordinate = manager.location?.coordinate {
                        print("No Region Monitoring currently, adding new region at \(coordinate)")
                        await addNewRegionAtCoordinate(coordinate: coordinate)
                        await saveCoordinate(coordinate: coordinate)
                    }
                    else {
                        print("Unable to get location...")
                    }
                }
                else {
                    print("Previous Monitor Region is used: \(String(describing: identifiers.first))")
                }
            }

            
            print("Start tracking events...")
            while continueTrackingRegions {
                for try await event in await monitor!.events {
                    
                    print("Region Update")
                    
                    if let coordinate = manager.location?.coordinate {
                        
                        await saveCoordinate(coordinate: coordinate)
                        print("removing condition from monitor")
                        
                        await monitor!.remove(event.identifier)
                        await addNewRegionAtCoordinate(coordinate: coordinate)
                        
                        await devNotification()
                        break
                    }
                }
                print("!!!!! Stopped waiting for events...")
            }
        }
    }
    
    func updatePoints() {
        print("Loading Points from storage")
        
        let pointDatePredicate : Predicate<Point> = dateFilter.predicate()
        
        let fetchDescriptor = FetchDescriptor<Point>(predicate: pointDatePredicate, sortBy: [SortDescriptor(\.date)])
        
        do {
            self.points = try self.context.fetch(fetchDescriptor).map {
                print($0.date)
                return CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude)
            }
        } catch {
            fatalError("Failed to load Point model.")
        }
    }
    
    
    func saveCoordinate(coordinate: CLLocationCoordinate2D) async {
        print("saving coordinate (long: \(coordinate.longitude) lat: \(coordinate.latitude))")
        let newLocationPoint = Point(longitude: coordinate.longitude, latitude: coordinate.latitude)
        context.insert(newLocationPoint)
        try! context.save()
        updatePoints()
    }
    
    
    func addNewRegionAtCoordinate(coordinate: CLLocationCoordinate2D) async {
        print("adding new condition to monitor \(coordinate)")
        let condition = CLMonitor.CircularGeographicCondition(center: coordinate, radius: pinTrackingDistanceMeters)
        await monitor!.add(condition, identifier: StaticData.regionName, assuming: .satisfied)
    }
    
    
    public func manuallySaveLocation() {
        Task {
            if let coordinate = manager.location?.coordinate {
                print("Manually Saving Current Location \(coordinate)")
                await saveCoordinate(coordinate: coordinate)
            }
        }
    }
    
    
    public func resetSavedData() {
        do {
            print("Clearing entire model")
            try context.delete(model: Point.self)
            manuallySaveLocation()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    public func hasVisited(latitude: Double, longitude: Double) -> Bool {
        let to = CLLocation(latitude: latitude, longitude: longitude)
        for point in points {
            let from = CLLocation(latitude: point.latitude, longitude: point.longitude)
            if to.distance(from: from) < visitedRangeMeters {
                return true
            }
        }
        return false
    }
    
    func getNumberOfPlacesVisited(playlist: Playlist) -> Int {
        var numVisited = 0
        for place in playlist.places {
            if hasVisited(latitude: place.latitude, longitude: place.longitude) {
                numVisited += 1
            }
        }
        return numVisited
    }
    
    
    
    
    
    public func devNotification() async {
        let content = UNMutableNotificationContent()
        content.title = "Feed the cat"
        if let coordinate = manager.location?.coordinate {
            content.subtitle = "long: \(coordinate.longitude) lat: \(coordinate.latitude)"
        }
        content.sound = UNNotificationSound.default
        // show this notification five seconds from now
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        // choose a random identifier
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        // add our notification request
        try! await UNUserNotificationCenter.current().add(request)
    }
}

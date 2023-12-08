//
//  LocationManagerDelegate.swift
//  TestBackgroundModelContext
//
//  Created by Nick Selvitelli on 11/8/23.
//

import CoreLocation

class LocationManagerDelegate : NSObject, CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("LOCATION AUTH CHANGED")
        switch status {
        case .authorizedAlways:
            break
        default:
            manager.requestAlwaysAuthorization()
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("LocationManager ERROR! \(error.localizedDescription)")
    }
    
}

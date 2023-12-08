//
//  DateFilter.swift
//  TestBackgroundModelContext
//
//  Created by Nick Selvitelli on 12/4/23.
//

import Foundation

enum DateFilter : CaseIterable {
    case Off
    case Day
    case Week
    case Month
    case Year
    
    func predicate() -> Predicate<Point> {
        
        let cutoffDate : Date? = switch self {
            case .Off:
                nil
            case .Day:
                Calendar.current.date(byAdding: DateComponents(day: -1), to: Date.now)
            case .Week:
                Calendar.current.date(byAdding: DateComponents(day: -7), to: Date.now)
            case .Month:
                Calendar.current.date(byAdding: DateComponents(month: -1), to: Date.now)
            case .Year:
                Calendar.current.date(byAdding: DateComponents(year: -1), to: Date.now)
        }
        
        if let date = cutoffDate {
            return #Predicate { point in
                point.date > date
            }
        }
        else {
            return #Predicate { point in
                true
            }
        }
        
    }
}

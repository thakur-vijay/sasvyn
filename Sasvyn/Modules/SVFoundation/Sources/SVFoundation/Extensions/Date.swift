//
//  File.swift
//  SVFoundation
//
//  Created by Vijay Thakur on 23/09/26.
//

import Foundation

public enum SVDateFormat: String, Sendable {
    
    // API / Database
    case isoDate = "yyyy-MM-dd"
    case isoDateTime = "yyyy-MM-dd'T'HH:mm:ss"
    case isoDateTimeWithMilliseconds = "yyyy-MM-dd'T'HH:mm:ss.SSS"
    
    // Common display formats
    case shortDate = "dd/MM/yyyy"
    case mediumDate = "dd MMM yyyy"
    case longDate = "dd MMMM yyyy"
    
    // Date + Time
    case shortDateTime = "dd/MM/yyyy, h:mm a"
    case mediumDateTime = "dd MMM yyyy, h:mm a"
    case longDateTime = "dd MMMM yyyy, h:mm a"
    
    // Month / Year
    case monthYear = "MMMM yyyy"
    case shortMonthYear = "MMM yyyy"
    
    // Time
    case shortTime = "h:mm a"
    case timeWithSeconds = "h:mm:ss a"
}

public extension Date {
    
    func formatted(
        _ format: SVDateFormat,
        timeZone: TimeZone = .current
    ) -> String {
        
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = timeZone
        formatter.dateFormat = format.rawValue
        
        return formatter.string(from: self)
    }
}

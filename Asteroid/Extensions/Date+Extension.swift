//
//  Date+Extension.swift
//  Asteroid
//
//  Created by Sreeni E V on 06/09/22.
//

import Foundation

extension Date {
    static func dates(from fromDate: Date, to toDate: Date) -> [Date] {
        var dates: [Date] = []
        var date = fromDate
        
        while date <= toDate {
            dates.append(date)
            guard let newDate = Calendar.current.date(byAdding: .day, value: 1, to: date) else { break }
            date = newDate
        }
        return dates
    }
    
    
     func toString(withFormat format: String = "yyyy-MM-dd") -> String {

           let dateFormatter = DateFormatter()
           dateFormatter.locale = Locale(identifier: "fa-IR")
           dateFormatter.timeZone = TimeZone(identifier: "Asia/Tehran")
           dateFormatter.calendar = Calendar(identifier: .persian)
           dateFormatter.dateFormat = format
           let str = dateFormatter.string(from: self)

           return str
       }
}

extension String {

    func toDate(withFormat format: String = "yyyy-MM-dd")-> Date?{

        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Tehran")
        dateFormatter.locale = Locale(identifier: "fa-IR")
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)

        return date

    }
}

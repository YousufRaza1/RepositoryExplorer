//
//  DateFormat.swift
//  RepositoryExplorer
//
//  Created by Yousuf on 2/1/24.
//

import SwiftUI

extension String {
    
    func convertDateFromString( format: String = "yyyy-MM-dd'T'HH:mm:ssZ") throws -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone(identifier: "PST")
        guard let date = dateFormatter.date(from: self) else {
            throw DateError.dateError
        }
        
        return date
    }
    
    enum DateError: Error {
        case dateError
    }
    
}

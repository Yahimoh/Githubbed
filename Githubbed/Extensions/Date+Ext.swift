//
//  Date+Ext.swift
//  Githubbed
//
//  Created by Mohamad Yahia on 12.1.2024.
//

import Foundation

extension Date {
    func convertToMonthYearFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"
        return dateFormatter.string(from: self)
    }
}

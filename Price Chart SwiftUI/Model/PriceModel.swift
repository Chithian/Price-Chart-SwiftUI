//
//  PriceModel.swift
//  Price Chart SwiftUI
//
//  Created by Samony Chithian on 14/1/23.
//

import Foundation


struct Price: Identifiable {
    var id = UUID().uuidString
    var hour: Date
    var price : Double
    var animate: Bool = false
}


extension Date{
    // MARK: To Update Date For Particular Hour
    func updateHour (value: Int)->Date{
        let calendar = Calendar.current
        return calendar.date(bySettingHour: value, minute: 0, second: 0, of: self) ?? .now
    }
}

var sample_analytics: [Price] = [
    Price(hour: Date().updateHour(value: 1), price: 100),
    Price(hour: Date().updateHour(value: 2), price: 625),
    Price(hour: Date().updateHour(value: 3), price: 200),
    Price(hour: Date().updateHour(value: 4), price: 325),
    Price(hour: Date().updateHour(value: 5), price: 500),
    Price(hour: Date().updateHour(value: 6), price: 625),
    Price(hour: Date().updateHour(value: 7), price: 400),
    Price(hour: Date().updateHour(value: 8), price: 625),
    Price(hour: Date().updateHour(value: 9), price: 600),
    Price(hour: Date().updateHour(value: 10), price: 400),
    Price(hour: Date().updateHour(value: 11), price: 625),
    Price(hour: Date().updateHour(value: 12), price: 600),
    Price(hour: Date().updateHour(value: 13), price: 400),
    Price(hour: Date().updateHour(value: 14), price: 625),
    Price(hour: Date().updateHour(value: 15), price: 600),
    Price(hour: Date().updateHour(value: 16), price: 400),
    Price(hour: Date().updateHour(value: 17), price: 625),
    Price(hour: Date().updateHour(value: 18), price: 600),
    Price(hour: Date().updateHour(value: 19), price: 400),
    Price(hour: Date().updateHour(value: 20), price: 625),
    Price(hour: Date().updateHour(value: 21), price: 600),
]


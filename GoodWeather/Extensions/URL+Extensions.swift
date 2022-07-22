//
//  URL+Extensions.swift
//  GoodWeather
//
//  Created by Flow_RyanChou on 2022/7/22.
//

import Foundation

extension URL {
    
    static func urlForWeatherAPI(city: String) -> URL? {
        return URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(city)i&appid=d368c69de63f2ab64074d2dfabe8176e")
    }
    
}

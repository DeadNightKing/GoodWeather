//
//  WeatherResult.swift
//  GoodWeather
//
//  Created by Flow_RyanChou on 2022/7/21.
//

import Foundation

struct WeatherResult: Decodable {
    let main: Weather
}

struct Weather: Decodable {
    let temp: Double
    let humidity: Double
}

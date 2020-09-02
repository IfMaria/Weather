//
//  WeatherData.swift
//  Weather
//
//  Created by Maria Kramer on 01.09.2020.
//  Copyright © 2020 Maria Kramer. All rights reserved.
//

import Foundation

struct WeatherData : Codable {
    let name : String
    let weather : [Weather]
    let main : Main
}

struct Weather : Codable {
    let id : Int
}

struct Main : Codable {
    let temp : Double
}

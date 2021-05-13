//
//  WeatherData.swift
//  WeatherApp
//
//  Created by Manuel Casocavallo on 12/05/21.
//

import Foundation

struct WeatherData: Decodable {
    let name: String
    let weather: [Weather]
    let main: Main
    let sys: Sys
    
    struct Weather: Decodable {
        let id: Int
    }
    
    struct Main: Decodable {
        let temp: Double
        let feels_like: Double
        let temp_min: Double
        let temp_max: Double
        let humidity: Int
    }
    
    struct Sys: Decodable {
        let sunrise: Int //unix, UTC
        let sunset: Int //unix, UTC
    }

    let timezone: Int //Shift in seconds from UTC
        
}


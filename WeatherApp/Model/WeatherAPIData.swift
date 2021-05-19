//
//  WeatherAPIData.swift
//  WeatherApp
//
//  Created by Manuel Casocavallo on 19/05/21.
//

import Foundation

struct WeatherAPIData: Decodable {
    let location: Location
    
    struct Location: Decodable {
        let name: String
        let region: String
        let lat: Double
        let lon: Double
        let tz_id: String           //Time zone name
        let localtime_epoch: Int    //Local date and time in unix time
        let localtime: String       //Local date and time
    }
    
    let current: Current
    
    struct Current: Decodable {
        let last_updated: String
        let temp_c: Float
        let temp_f: Float
        let is_day: Int
        let condition: Condition
        
        struct Condition: Decodable {
            let text: String
            let code: Int
        }
        
        let wind_mph: Float
        let wind_kph: Float
        let wind_degree: Int
        let wind_dir: String
        let precip_mm: Float
        let precip_in: Float
        let humidity: Int
        let feelslike_c: Float
        let feelslike_f: Float
        let vis_km: Int
        let vis_miles: Int
        let uv: Int
        
        let air_quality: AirQuality
        
        struct AirQuality: Decodable {
            let co: Double          //Carbon Monoxide (μg/m3)
            let no2: Double         //Ozone (μg/m3)
            let o3: Double          //Nitrogen Dioxide (μg/m3)
            let so2: Double         //Sulphur Dioxide  (μg/m3)
            let pm2_5: Double       //PM2.5 (μg/m3)
            let pm10: Double        //PM10 (μg/m3)
            
            let USEpaIndex: Int
            /* US-EPA standard
             1: Good
             2: Moderate
             3: Unhealthy for sensitive group
             4: Unhealthy
             5: Very unhealthy
             6: Hazardous
            */
            
            let GBDefraIndex: Int
            /* UK Defra Index (μg/m3)
             1: Low (0-11)
             2: Low (12-23)
             3: Low (24-35)
             4: Moderate (36-41)
             5: Moderate (42-47)
             6: Moderate (48-53)
             7: High (54-58)
             8: High (59-64)
             9: High (65-70)
             10: Very High (71 or more)
             */
            
            enum CodingKeys: String, CodingKey {
                case co, no2, o3, so2, pm2_5, pm10
                case USEpaIndex = "us-epa-index"
                case GBDefraIndex = "gb-defra-index"
            }
            
        }
        
    }
    
    let forecast: Forecast
    
    struct Forecast: Decodable {
        let forecastday: [Forecastday]
    
        struct Forecastday: Decodable {
            let date: String
            let day: Day
            
            struct Day: Decodable {
                let maxtemp_c: Float
                let maxtemp_f: Float
                let mintemp_c: Float
                let mintemp_f: Float
                let avgtemp_c: Float
                let avgtemp_f: Float
                let maxwind_mph: Float
                let maxwind_kph: Float
                let totalprecip_mm: Float
                let totalprecip_in: Float
                let avgvis_km: Float
                let avgvis_miles: Float
                let avghumidity: Float
                let daily_will_it_rain: Int
                let daily_chance_of_rain: String
                let daily_will_it_snow: Int
                let daily_chance_of_snow: String
                
                let condition: Condition
                
                struct Condition: Decodable {
                    let text: String
                    let code: Int
                }
                
                let uv: Int
            }
            
            let astro: Astro
            
            struct Astro: Decodable {
                let sunrise: String
                let sunset: String
                let moonrise: String
                let moonset: String
                let moon_phase: String
                let moon_illumination: String
            }
        }
    }
    
    
}

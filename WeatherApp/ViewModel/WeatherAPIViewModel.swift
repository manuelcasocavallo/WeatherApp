//
//  WeatherAPIViewModel.swift
//  WeatherApp
//
//  Created by Manuel Casocavallo on 19/05/21.
//

import Foundation

class WeatherAPIViewModel: ObservableObject {
    
    struct CurrentData {
        var name: String = ""
        var temp: String = ""
        var tempMin: String = ""
        var tempMax: String = ""
        var humidity: Int = 0
        var id: Int = 0
        var feelsLike: String = ""
        var conditionsImageName: String = ""
        var sunrise: String = ""
        var sunset: String = ""

    }
    
        @Published var currentData = CurrentData()

    
//
//    struct HourlyForecast {
//        //12h forecast data: hour - conditionsImage - temp
//    }
//
//    struct WeeklyForecast {
//        //7 days forecast data: day - conditionsImage - temp
//    }
//
//    @Published var currentData = CurrentData()
//    @Published var hourlyForecast = HourlyForecast()
//    @Published var weeklyForecast = WeeklyForecast()
//
//    @Published var isMetric: Bool = true
//
    
    let baseURL = "https://api.weatherapi.com/v1/forecast.json?key=\(WAPIKey)&q="
    
    func updateWeather(city: String) {
        let cityName = city.replacingOccurrences(of: " ", with: "%20")
        guard let url = URL(string: baseURL + cityName + "&days=7&aqi=yes&alerts=no") else { return }

        print(url)

        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
            guard let data = data, error == nil else { return }
            let decoder = JSONDecoder()
            do {
                let result = try decoder.decode(WeatherAPIData.self, from: data)
                DispatchQueue.main.async {
                    self.currentData.name = result.location.name
                    self.currentData.temp = String(format: "%.1f", result.current.temp_c)
                    self.currentData.tempMin = String(format: "%.0f", result.forecast.forecastday[0].day.mintemp_c)
                    self.currentData.tempMax = String(format: "%.0f", result.forecast.forecastday[0].day.maxtemp_c)
                    self.currentData.humidity = result.current.humidity
                    self.currentData.id = result.current.condition.code
                    self.currentData.feelsLike = String(format: "%.1f", result.current.feelslike_c)
                    self.currentData.sunrise = result.forecast.forecastday[0].astro.sunrise
                    self.currentData.sunset = result.forecast.forecastday[0].astro.sunset
                    self.currentData.conditionsImageName = self.updateImageName(id: result.current.condition.code, isNight: false)
                    print("Success\nCity: \(result.location.name)\nTemp: \(String(format: "%.1f", result.current.temp_c))\nFeels like: \(String(format: "%.1f", result.current.feelslike_c))")
                }
            } catch {
                print("HERE \(error.localizedDescription)")
            }
        }
        task.resume()
    }

    
    func updateImageName(id: Int, isNight: Bool) -> String {
        switch id {
        case 200...299:     //Thunderstorm
            return "cloud.bolt.rain"
        case 300...399:     //Drizzle
            return "cloud.drizzle"
        case 500...599:     //Rain
            return "cloud.heavyrain"
        case 600...699:     //Snow
            return "snow"
        case 700...780:     //Atmosphere
            return "cloud.fog"
        case 781:           //Tornado
            return "tornado"
        case 800:           //Clear
            return isNight ? "moon" : "sun.max"
        case 801...899:     //Clouds
            return isNight ? "cloud.moon" : "cloud.sun"
        default:
            return "sparkles"
        }
    }
    
}

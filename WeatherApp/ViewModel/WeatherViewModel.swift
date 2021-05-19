////
////  WeatherViewModel.swift
////  WeatherApp
////
////  Created by Manuel Casocavallo on 12/05/21.
////
//
//import Foundation
//
//class WeatherViewModel: ObservableObject {
//    
//    struct CurrentData {
//        var name: String = ""
//        var temp: String = ""
//        var tempMin: String = ""
//        var tempMax: String = ""
//        var humidity: Int = 0
//        var id: Int = 0
//        var feelsLike: String = ""
//        var conditionsImageName: String = ""
//        var sunrise: Int = 0
//        var sunset: Int = 0
//        
//    }
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
//    
//    
//    //MARK: - Current data
//    
//    let baseURL = "https://api.openweathermap.org/data/2.5/weather?"    
//    
//    func updateWeather(city: String) {
//        let cityName = "q=\(city.replacingOccurrences(of: " ", with: "%20"))"
//        let unit = "&units=\(isMetric ? "metric" : "imperial")"
//
//        guard let url = URL(string: baseURL + cityName + unit + OWKey) else { return }
//        
//        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
//            guard let data = data, error == nil else { return }
//            let decoder = JSONDecoder()
//            do {
//                let result = try decoder.decode(WeatherData.self, from: data)
//                DispatchQueue.main.async {
//                    self.currentData.name = result.name
//                    self.currentData.temp = String(format: "%.1f", result.main.temp)
//                    self.currentData.tempMin = String(format: "%.0f", result.main.temp_min)
//                    self.currentData.tempMax = String(format: "%.0f", result.main.temp_max)
//                    self.currentData.humidity = result.main.humidity
//                    self.currentData.id = result.weather[0].id
//                    self.currentData.feelsLike = String(format: "%.1f", result.main.feels_like)
//                    self.currentData.sunrise = result.sys.sunrise
//                    self.currentData.sunset = result.sys.sunset 
//                    self.currentData.conditionsImageName = self.updateImageName(id: result.weather[0].id, isNight: false)
//                }
//            } catch {
//                print(error.localizedDescription)
//            }
//        }
//        task.resume()
//    }
//    
//    func updateImageName(id: Int, isNight: Bool) -> String {
//        switch id {
//        case 200...299:     //Thunderstorm
//            return "cloud.bolt.rain"
//        case 300...399:     //Drizzle
//            return "cloud.drizzle"
//        case 500...599:     //Rain
//            return "cloud.heavyrain"
//        case 600...699:     //Snow
//            return "snow"
//        case 700...780:     //Atmosphere
//            return "cloud.fog"
//        case 781:           //Tornado
//            return "tornado"
//        case 800:           //Clear
//            return isNight ? "moon" : "sun.max"
//        case 801...899:     //Clouds
//            return isNight ? "cloud.moon" : "cloud.sun"
//        default:
//            return "sparkles"
//        }
//    }
//    
//    
//    
//    //MARK: - Hourly forecast
//    
//    let WeatherAPIBaseURL = "https://api.weatherapi.com/v1/key=\(WAPIKey)/q="
//    let forecastRequest = ""
//    
//    //MARK: - Weekly forecast
//    
//    
//    
//    
//}

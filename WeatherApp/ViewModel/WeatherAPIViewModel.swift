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
    @Published var isMetric: Bool = true

    
    //
    //    struct HourlyForecast {
    //        //12h forecast data: hour - conditionsImage - temp
    //    }
    //
    //    struct WeeklyForecast {
    //        //7 days forecast data: day - conditionsImage - temp
    //    }
    //
    //    @Published var hourlyForecast = HourlyForecast()
    //    @Published var weeklyForecast = WeeklyForecast()
    //
    //
    
    let baseURL = "https://api.weatherapi.com/v1/forecast.json?key=\(WAPIKey)&q="
    
    func updateWeather(city: String, isMetric: Bool) {
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
                    self.currentData.temp = String(format: "%.1f", isMetric ? result.current.temp_c : result.current.temp_f)
                    self.currentData.tempMin = String(format: "%.0f", isMetric ? result.forecast.forecastday[0].day.mintemp_c : result.forecast.forecastday[0].day.mintemp_f)
                    self.currentData.tempMax = String(format: "%.0f", isMetric ? result.forecast.forecastday[0].day.maxtemp_c : result.forecast.forecastday[0].day.maxtemp_f)
                    self.currentData.humidity = result.current.humidity
                    self.currentData.id = result.current.condition.code
                    self.currentData.feelsLike = String(format: "%.1f", isMetric ? result.current.feelslike_c : result.current.feelslike_f)
                    self.currentData.sunrise = result.forecast.forecastday[0].astro.sunrise
                    self.currentData.sunset = result.forecast.forecastday[0].astro.sunset
                    
                    //TODO: Implement a day/night recognition system
                    
                    self.currentData.conditionsImageName = self.updateImageName(id: result.current.condition.code, isNight: false)
                    
                    print("Success\nCity: \(result.location.name)\nTemp: \(String(format: "%.1f", result.current.temp_c))\nFeels like: \(String(format: "%.1f", result.current.feelslike_c))")
                }
            } catch {
                print("Error:\n\(error.localizedDescription)")
            }
        }
        task.resume()
    }
    
    
    func updateImageName(id: Int, isNight: Bool) -> String {
        switch id {
        case 1000: //Sunny
            return isNight ? "moon" : "sun.max" //113
        case 1003: //Partly Cloudy
            return isNight ? "cloud.moon" : "cloud.sun" //116
        case 1006: //Cloudy
            return "cloud" //119
        case 1009: //Overcast
            return "smoke" //122
        case 1030: //Mist
            return "cloud.fog" //143
        case 1063: //Patchy rain possible
            return isNight ? "cloud.moon.rain" : "cloud.sun.rain" //176
        case 1066: //Patchy snow possible
            return "cloud.snow" //179
        case 1069: // Patchy sleet possible
            return "cloud.hail" //182
        case 1072: // Patchy freezing drizzle possible
            return "cloud.sleet" //185
        case 1087: //Thundery outbreaks possible
            return isNight ? "cloud.moon.bolt" : "cloud.sun.bolt" //200
        case 1114: //Blowing snow
            return "wind.snow" //227
        case 1117: //Blizzard
            return "wind.snow" //230
        case 1135: //Fog
            return "cloud.fog" //248
        case 1147: //Freezing fog
            return "cloud.fog" //260
        case 1150: //Patchy light drizzle
            return "cloud.drizzle" //263
        case 1153: //Light drizzle
            return "cloud.drizzle" //266
        case 1168: //Freezing drizzle
            return "cloud.drizzle" //281
        case 1171: //Heavy freezing drizzle
            return "cloud.drizzle" //284
        case 1180: //Patchy light rain
            return isNight ? "cloud.moon.rain" : "cloud.sun.rain" //293
        case 1183: //Light rain
            return "cloud.drizzle" //296
        case 1186: //Moderate rain at times
            return isNight ? "cloud.moon.rain" : "cloud.sun.rain" //299
        case 1189: //Moderate rain
            return "cloud.rain" //302
        case 1192: //Heavy rain at times
            return "cloud.heavyrain" //305
        case 1195: //Heavy rain
            return "cloud.heavyrain.fill" //308
        case 1198: //Light freezing rain
            return "cloud.rain" //311
        case 1201: //Moderate or heavy freezing rain
            return "cloud.heavyrain" //314
        case 1204: //Light sleet
            return "cloud.sleet.fill" //317
        case 1207: //Moderate or heavy sleet
            return "cloud.sleet" //320
        case 1210: //Patchy light snow
            return "cloud.sleet" //323
        case 1213: // Light snow
            return "cloud.sleet" //326
        case 1216: //Patchy moderate snow
            return "cloud.snow" //329
        case 1219: //Moderate snow
            return "cloud.snow" //332
        case 1222: //Patchy heavy snow
            return "cloud.snow.fill" //335
        case 1225: //Heavy snow
            return "snow" //338
        case 1237: //Ice pellets
            return "cloud.hail" //350
        case 1240: //Light rain showers
            return isNight ? "cloud.moon.rain" : "cloud.sun.rain" //353
        case 1243: //Moderate or heavy rain showers
            return isNight ? "cloud.moon.rain.fill" : "cloud.sun.rain.fill" //356
        case 1246: //Torrential rain shower
            return "cloud.heavyrain.fill" //359
        case 1249: //Light sleet shower
            return "cloud.sleet" //362
        case 1252: //Moderate or heavy sleet showers
            return "cloud.sleet.fill" //365
        case 1255: //Light snow showers
            return "cloud.snow" //368
        case 1258: //Moderate or heavy snow showers
            return "cloud.snow.fill" //371
        case 1261: //Light showers of ice pellets
            return "cloud.hail" //374
        case 1264: //Moderate or heavy showers of ice pellets
            return "cloud.hail.fill" //377
        case 1273: //Patchy light rain with thunder
            return isNight ? "cloud.moon.bolt" : "cloud.sun.bolt" //386
        case 1276: //Moderate or heavy rain with thunder
            return isNight ? "cloud.bolt.rain" : "cloud.bolt.rain.fill" //389
        case 1279: //Patchy light snow with thunder
            return "cloud.snow" //392
        case 1282: //Moderate or heavy snow with thunder
            return "cloud.snow.fill" //395
        default:
            return "sparkles"
        }
    }
    
}

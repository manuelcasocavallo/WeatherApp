//
//  WeatherAPIViewModel.swift
//  WeatherApp
//
//  Created by Manuel Casocavallo on 19/05/21.
//

import Foundation

class WeatherAPIViewModel: ObservableObject {
    
    @Published var isMetric: Bool = true
    @Published var isDay: Bool = false
    @Published var currentDate: Date = Date()
    
    @Published var currentData = CurrentData()
    struct CurrentData {
        var name: String = ""
        var temp: String = ""
        var tempMin: String = ""
        var tempMax: String = ""
        var humidity: Int = 0
        var feelsLike: String = ""
        var conditionsImageName: String = ""
        var sunrise: String = ""
        var sunset: String = ""
        
    }
    
    @Published var hourlyForecast = [ForecastDay]()
    struct ForecastDay {
        var date: Date = Date()         //String yyyy-MM-dd
        var dateEpoch: Int = 0      //unix time
        
        var tempMin: String = ""
        var tempMax: String = ""
        var tempAvg: String = ""
        var maxWind: String = ""
        var totalPrecip: String = ""
        var dailyChanceOfRain: String = ""
        var conditionText: String = ""
        var conditionImageName: String = ""
        var uv: Float = 0
        
        var hours = [Hour]()
        struct Hour {
            var timeEpoch: Int = 0  //unix time
            var time: Date      //yyyy-MM-dd hh:mm String
            var temp: String = ""
            var isDay: Bool = true     //Int -> Bool (1=t, 0=f)
            var conditionText: String = ""
            var conditionImageName: String = ""
            var precip: Float = 0
        }
    }
    
    
    let baseURL = "https://api.weatherapi.com/v1/forecast.json?key=\(WAPIKey)&q="
    
    func updateWeather(city: String, isMetric: Bool) {
        let formatter1 = DateFormatter()
        formatter1.dateFormat = "yyyy-MM-dd"
        let formatter2 = DateFormatter()
        formatter2.dateFormat = "yyyy-MM-dd HH:mm"
        
        let cityName = city.replacingOccurrences(of: " ", with: "%20")
        guard let url = URL(string: baseURL + cityName + "&days=7&aqi=yes&alerts=no") else { return }
        
        print(url)
        
        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
            guard let data = data, error == nil else { return }
            let decoder = JSONDecoder()
            do {
                let result = try decoder.decode(WeatherAPIData.self, from: data)
                DispatchQueue.main.async {
                    
                    self.isDay = result.current.is_day == 1
                    
                    //MARK: - Update Current Data
                    
                    self.currentData.name = result.location.name
                    self.currentData.temp = String(format: "%.1f", isMetric ? result.current.temp_c : result.current.temp_f)
                    self.currentData.tempMin = String(format: "%.0f", isMetric ? result.forecast.forecastday[0].day.mintemp_c : result.forecast.forecastday[0].day.mintemp_f)
                    self.currentData.tempMax = String(format: "%.0f", isMetric ? result.forecast.forecastday[0].day.maxtemp_c : result.forecast.forecastday[0].day.maxtemp_f)
                    self.currentData.humidity = result.current.humidity
                    self.currentData.feelsLike = String(format: "%.1f", isMetric ? result.current.feelslike_c : result.current.feelslike_f)
                    self.currentData.sunrise = result.forecast.forecastday[0].astro.sunrise
                    self.currentData.sunset = result.forecast.forecastday[0].astro.sunset
                    
                    
                    self.currentData.conditionsImageName = self.updateImageName(id: result.current.condition.code, isDay: self.isDay)
                    
                    
                    
                    //MARK: - Update Hourly Forecast
                    
                    for d in 0...2 {
                        var forecastDay = ForecastDay(
                            date: formatter1.date(from: result.forecast.forecastday[d].date) ?? self.currentDate,
                            dateEpoch: result.forecast.forecastday[d].date_epoch,
                            tempMin: String(format: "%.1f", isMetric ? result.forecast.forecastday[d].day.mintemp_c : result.forecast.forecastday[d].day.mintemp_c),
                            tempMax: String(format: "%.1f", isMetric ? result.forecast.forecastday[d].day.maxtemp_c : result.forecast.forecastday[d].day.maxtemp_c),
                            tempAvg: String(format: "%.1f", isMetric ? result.forecast.forecastday[d].day.avgtemp_c : result.forecast.forecastday[d].day.avgtemp_c),
                            maxWind: String(format: "%.1f", isMetric ? result.forecast.forecastday[d].day.maxwind_kph : result.forecast.forecastday[d].day.maxwind_mph),
                            totalPrecip: String(format: "%.1f", isMetric ? result.forecast.forecastday[d].day.totalprecip_mm : result.forecast.forecastday[d].day.totalprecip_in),
                            dailyChanceOfRain: result.forecast.forecastday[d].day.daily_chance_of_rain,
                            conditionText: result.forecast.forecastday[d].day.condition.text,
                            conditionImageName: self.updateImageName(id: result.forecast.forecastday[d].day.condition.code, isDay: true),
                            uv: result.forecast.forecastday[d].day.uv
                        )

                        for h in 0...23 {
                            let hour = ForecastDay.Hour(
                                timeEpoch: result.forecast.forecastday[d].hour[h].time_epoch,
                                time: formatter2.date(from: result.forecast.forecastday[d].hour[h].time) ?? self.currentDate,
                                temp: isMetric ? String(format: "%.1f", result.forecast.forecastday[d].hour[h].temp_c) : String(format: "%.1f", result.forecast.forecastday[d].hour[h].temp_f),
                                isDay: result.forecast.forecastday[d].hour[h].is_day == 1,
                                conditionText: result.forecast.forecastday[d].hour[h].condition.text,
                                conditionImageName: self.updateImageName(id: result.forecast.forecastday[d].hour[h].condition.code, isDay: result.forecast.forecastday[d].hour[h].is_day == 1),
                                precip: isMetric ? result.forecast.forecastday[d].hour[h].precip_mm : result.forecast.forecastday[d].hour[h].precip_in
                            )
                            forecastDay.hours.append(hour)
                        }
                        self.hourlyForecast.append(forecastDay)
                        print(forecastDay)
                    }
                    
                    print("Success\nCity: \(result.location.name)\nTemp: \(String(format: "%.1f", result.current.temp_c))\nFeels like: \(String(format: "%.1f", result.current.feelslike_c))")
                }
            } catch {
                print("Error:\n\(error.localizedDescription)")
            }
        }
        task.resume()
    }
    
    
    func updateImageName(id: Int, isDay: Bool) -> String {
        switch id {
        case 1000: //Sunny
            return isDay ? "sun.max" : "moon" //113
        case 1003: //Partly Cloudy
            return isDay ? "cloud.sun" : "cloud.moon" //116
        case 1006: //Cloudy
            return "cloud" //119
        case 1009: //Overcast
            return "smoke" //122
        case 1030: //Mist
            return "cloud.fog" //143
        case 1063: //Patchy rain possible
            return isDay ? "cloud.sun.rain" : "cloud.moon.rain" //176
        case 1066: //Patchy snow possible
            return "cloud.snow" //179
        case 1069: // Patchy sleet possible
            return "cloud.hail" //182
        case 1072: // Patchy freezing drizzle possible
            return "cloud.sleet" //185
        case 1087: //Thundery outbreaks possible
            return isDay ? "cloud.sun.bolt" : "cloud.moon.bolt" //200
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
            return isDay ? "cloud.sun.rain" : "cloud.moon.rain" //293
        case 1183: //Light rain
            return "cloud.drizzle" //296
        case 1186: //Moderate rain at times
            return isDay ? "cloud.sun.rain" : "cloud.moon.rain" //299
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
            return isDay ? "cloud.sun.rain" : "cloud.moon.rain" //353
        case 1243: //Moderate or heavy rain showers
            return isDay ? "cloud.sun.rain.fill" : "cloud.moon.rain.fill" //356
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
            return isDay ? "cloud.sun.bolt" : "cloud.moon.bolt" //386
        case 1276: //Moderate or heavy rain with thunder
            return isDay ? "cloud.bolt.rain" : "cloud.bolt.rain.fill" //389
        case 1279: //Patchy light snow with thunder
            return "cloud.snow" //392
        case 1282: //Moderate or heavy snow with thunder
            return "cloud.snow.fill" //395
        default:
            return "sparkles"
        }
    }
}

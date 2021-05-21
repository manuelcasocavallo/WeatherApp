//
//  CurrentWeatherView.swift
//  WeatherApp
//
//  Created by Manuel Casocavallo on 12/05/21.
//

import SwiftUI

struct CurrentWeatherView: View {
    @EnvironmentObject var weatherAPIViewModel: WeatherAPIViewModel
    @State private var isFavourite: Bool = false
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                
                HStack(alignment: .center) {
                    Text(weatherAPIViewModel.currentData.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Image(systemName: isFavourite ? "heart.fill" : "heart")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 22, height: 22)
                        .padding(.leading, 4)
                        .foregroundColor(.red)
                        .onTapGesture {
                            isFavourite.toggle()
                        }
                }
                .padding([.trailing, .top])
                
                HStack {
                    HStack(alignment: .center) {
                        Image(systemName: weatherAPIViewModel.currentData.conditionsImageName)
                            .resizable()
                            .scaledToFit()
                            .padding()
                            .frame(height: geo.size.width / 2)
                    }
                                                            
                    VStack(alignment: .trailing) {
                        
                        VStack(alignment: .trailing) {
                            Text(weatherAPIViewModel.currentData.temp + (weatherAPIViewModel.isMetric ? "°C" : "F°"))
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .padding()
                        }
                        
                        VStack(alignment: .trailing) {
                            HStack {
                                Text("Feels like")
                                Text(weatherAPIViewModel.currentData.feelsLike + (weatherAPIViewModel.isMetric ? "°C" : "F°"))
                            }

                            HStack {
                                Text("Humidity: ")
                                Text("\(weatherAPIViewModel.currentData.humidity)")
                                Text("%")
                            }
                            
                            HStack {
                                Image(systemName: "thermometer")
                                Text("\(weatherAPIViewModel.currentData.tempMin + (weatherAPIViewModel.isMetric ? "°C" : "F°"))")
                                Text("/")
                                Text("\(weatherAPIViewModel.currentData.tempMax + (weatherAPIViewModel.isMetric ? "°C" : "F°"))")
                            }
                            
                            VStack {
                                HStack {
                                    Image(systemName: "sunrise.fill")
                                    Text(weatherAPIViewModel.currentData.sunrise)
                                }
                                HStack {
                                    Image(systemName: "sunset.fill")
                                    Text(weatherAPIViewModel.currentData.sunset)
                                }
                            }


                        }
                        .padding(.horizontal)
                        
                    }
                }
                .frame(width: geo.size.width)
                .padding(.bottom)
                
                ScrollView(.horizontal, showsIndicators: true) {
                    HStack {
                        ForEach(0..<12) { hour in
                            VStack(spacing: 10) {
                                Text("\(hour + 1):00")
                                    .font(.caption)
                                Text("20°C")
                            }
                            .padding()
                            .background(Color.secondary)
                            .cornerRadius(10)
                            .padding(.trailing, hour == 11 ? 16 : 0)

                        }
                    }
                }
                .padding(.vertical)
                
            }
            .padding(.vertical)
            .frame(width: geo.size.width)
            
        }
        .onAppear {
            weatherAPIViewModel.currentDate = Date()
            weatherAPIViewModel.updateWeather(city: "London", isMetric: true)
            print(weatherAPIViewModel.hourlyForecast)
        }
    }
}

struct CurrentWeatherView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentWeatherView()
            .environmentObject(WeatherAPIViewModel())
    }
}

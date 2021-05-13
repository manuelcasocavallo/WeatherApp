//
//  CurrentWeatherView.swift
//  WeatherApp
//
//  Created by Manuel Casocavallo on 12/05/21.
//

import SwiftUI

struct CurrentWeatherView: View {
    @EnvironmentObject var weatherViewModel: WeatherViewModel
    @State private var isFavourite: Bool = false
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                
                HStack(alignment: .center) {
                    Text(weatherViewModel.currentData.name)
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
                        Image(systemName: weatherViewModel.currentData.conditionsImageName)
                            .resizable()
                            .scaledToFit()
                            .frame(height: geo.size.width / 3.3)
                            .padding()
                    }
                                                            
                    VStack(alignment: .trailing) {
                        
                        VStack(alignment: .trailing) {
                            Text(weatherViewModel.currentData.temp + (weatherViewModel.isMetric ? "°C" : "F°"))
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .padding()
                        }
                        
                        VStack(alignment: .trailing) {
                            HStack {
                                Text("Feels like")
                                Text(weatherViewModel.currentData.feelsLike + (weatherViewModel.isMetric ? "°C" : "F°"))
                            }

                            HStack {
                                Text("Humidity: ")
                                Text("\(weatherViewModel.currentData.humidity)")
                                Text("%")
                            }
                            
                            HStack {
                                Image(systemName: "thermometer")
                                Text("\(weatherViewModel.currentData.tempMin + (weatherViewModel.isMetric ? "°C" : "F°"))")
                                Text("-")
                                Text("\(weatherViewModel.currentData.tempMax + (weatherViewModel.isMetric ? "°C" : "F°"))")
                            }
                            
                            HStack {
                                HStack {
                                    Image(systemName: "sunrise.fill")
                                    Text("6.00")
                                }
                                HStack {
                                    Image(systemName: "sunset.fill")
                                    Text("17.21")
                                }
                            }


                        }
                        .padding(.horizontal)
                        
                    }
                }
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
            weatherViewModel.updateWeather(city: "London")
        }
    }
}

struct CurrentWeatherView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentWeatherView()
            .environmentObject(WeatherViewModel())
    }
}

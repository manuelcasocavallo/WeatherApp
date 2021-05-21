//
//  ContentView.swift
//  WeatherApp
//
//  Created by Manuel Casocavallo on 12/05/21.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        ZStack {
            VStack {
                SearchBarView()
                    .padding(.top)
                
                CurrentWeatherView()
                    .padding(.leading)
                
                
                WeeklyWeatherView()
                    .padding(.leading)
                
                Spacer(minLength: 50)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(WeatherAPIViewModel())
    }
}

//
//  WeatherAppApp.swift
//  WeatherApp
//
//  Created by Manuel Casocavallo on 12/05/21.
//

import SwiftUI

@main
struct WeatherAppApp: App {
    @StateObject private var weatherViewModel = WeatherViewModel()
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(weatherViewModel)
        }
    }
}

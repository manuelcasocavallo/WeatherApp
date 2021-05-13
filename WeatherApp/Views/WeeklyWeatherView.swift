//
//  WeeklyWeatherView.swift
//  WeatherApp
//
//  Created by Manuel Casocavallo on 12/05/21.
//

import SwiftUI

struct WeeklyWeatherView: View {
    var body: some View {
        ScrollView(.horizontal, showsIndicators: true) {
            HStack(spacing: 16) {
                ForEach(0..<7) { day in
                    VStack(alignment: .center) {
                        Text("Day \(day + 1)")
                            .padding(.top)
                        Image(systemName: "sun.max.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                        Text("20°C")
                            .padding(.bottom)
                    }
                    .padding(.horizontal)
                    .background(Color.secondary)
                    .cornerRadius(10)
                    .padding(.trailing, day == 6 ? 16 : 0)
                }
            }
        }
    }
}

struct WeeklyWeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeeklyWeatherView()
    }
}

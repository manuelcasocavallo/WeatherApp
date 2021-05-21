//
//  WeeklyWeatherView.swift
//  WeatherApp
//
//  Created by Manuel Casocavallo on 12/05/21.
//

import SwiftUI

struct WeeklyWeatherView: View {
    @EnvironmentObject var weatherApiViewModel: WeatherAPIViewModel
    var body: some View {
        
        GeometryReader { geo in
            ScrollView(.horizontal, showsIndicators: true) {
                HStack(spacing: 16) {
                    ForEach(0..<3) { day in
                        VStack(alignment: .center) {
                            Text("\(day + 1)")
                                .padding(.top)
                            Image(systemName: "sun.fill")
                                .resizable()
                                .frame(width: 50, height: 50)
                            Text("20.0 °C")
                                .padding(.bottom)
                        }
                        .frame(width: geo.size.width / 2, height: geo.size.width / 1.75)
                        .padding(.horizontal)
                        .background(Color.secondary)
                        .cornerRadius(10)
                        .padding(.trailing, day == 6 ? 16 : 0)
                    }
                }
            }
            .frame(width: geo.size.width, height: geo.size.height, alignment: .bottom)
        }
    }
}


struct WeeklyWeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeeklyWeatherView()
            .environmentObject(WeatherAPIViewModel())
    }
}

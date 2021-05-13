//
//  SearchBarView.swift
//  WeatherApp
//
//  Created by Manuel Casocavallo on 12/05/21.
//

import SwiftUI

struct SearchBarView: View {
    @EnvironmentObject var weatherViewModel: WeatherViewModel
    @State private var textfieldText = ""
    
    var body: some View {
        HStack {
            Button {
                //GPS Search
            } label: {
                Image(systemName: "location.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .rotationEffect(Angle(degrees: 45))
                    .padding(.leading)
            }
            
            HStack {
                TextField("Search...", text: $textfieldText)
                    .font(.title3)
                    .frame(width: .infinity, height: 50)
                
                Button {
                    weatherViewModel.updateWeather(city: textfieldText)
                } label: {
                    Image(systemName: "magnifyingglass.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .padding(.trailing, 10)
                }
            }
            .padding(.leading)
            .background(Color.secondary)
            .cornerRadius(10)
            .padding(.trailing)
            
        }
    }
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarView()
    }
}

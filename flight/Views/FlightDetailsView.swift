//
//  FlightDetailsView.swift
//  flight
//
//  Created by Иван Легенький on 22.12.2023.
//

import SwiftUI

struct FlightDetailsView: View {
    var alligment: HorizontalAlignment = .leading
    var place: String
    var code: String
    var timing: String
    
    var body: some View {
        VStack(alignment: alligment, spacing: 6) {
            Text(place)
                .font(.caption)
                .foregroundColor(.white.opacity(0.8))
            Text(code)
                .font(.title)
                .foregroundColor(.white)
            Text(timing)
                .font(.caption)
                .foregroundColor(.white.opacity(0.8))
        }
        .frame(maxWidth: .infinity)
    }
}

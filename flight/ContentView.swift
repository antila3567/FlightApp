//
//  ContentView.swift
//  flight
//
//  Created by Иван Легенький on 22.12.2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        GeometryReader {
            let size = $0.size
            let safeArea = $0.safeAreaInsets
            Home(size: size, safeArea: safeArea)
                .ignoresSafeArea(.container, edges: .vertical)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

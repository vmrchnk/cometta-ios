//
//  SplashView.swift
//  Cometta
//
//  Created on 07.11.2025.
//

import Lottie
import SwiftUI

struct SplashView: View {
    @Environment(\.theme) var theme
    
    var body: some View {
        ZStack {
            theme.colors.background
                .ignoresSafeArea()
            VStack {
                Spacer()
                Text("Cometta")
                    .font(.title)
                    .fontWeight(.thin)
                    .foregroundStyle(
                        theme.colors.onBackground
                    )
            }
        }
    }
}

#Preview("Light") {
    SplashView()
        .theme(.default)
}

#Preview("Dark") {
    SplashView()
        .theme(.default)
}

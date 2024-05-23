//
//  BackgroundView.swift
//  Coolvert
//
//  Created by Alysson Reis on 22/05/2024.
//

import SwiftUI

struct BackgroundView<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.color2, Color.color3, Color.color4]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            content
        }
    }
}

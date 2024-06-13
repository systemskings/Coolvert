//
//  LoadingView.swift
//  Coolvert
//
//  Created by Alysson Reis on 11/06/2024.
//

import SwiftUI

struct LoadingView: View {
    @State private var isBlinking = false
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.8)
                .edgesIgnoringSafeArea(.all)
            VStack {
                Image("Logo1")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 260, height: 260)
                    .padding(.bottom, 1)
                    .opacity(isBlinking ? 0.3 : 1.0) // Alterar a opacidade para efeito de piscar
                    .onAppear {
                        withAnimation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                            isBlinking.toggle()
                        }
                    }
            }
        }
    }
}

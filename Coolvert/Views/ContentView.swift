//
//  ContentView.swift
//  Coolvert
//
//  Created by Alysson Reis on 10/05/2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            VStack {
                    
                    Image("Logo1")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 360, height: 360)
                
                    Text("Coolvert")
                        .font(.system(size: 40, weight: .bold, design: .default))
                        .foregroundColor(.white)
                        .padding()
                      
                    
                    NavigationLink(destination: SignInView()) {
                        Text("Sign In")
                            .padding()
                            .frame(maxWidth: 120)
                            .foregroundColor(.white)
                            .background(Color.color4)
                            .cornerRadius(8)
                    }
                    .padding()
                    
                    NavigationLink(destination: SignUpView()) {
                        Text("Sign Up")
                            .padding()
                            .frame(maxWidth: 120)
                            .foregroundColor(.white)
                            .background(Color.color5)
                            .cornerRadius(8)
                    }
                    .padding()
            }
        }
    }
}

#Preview {
    ContentView()
}

//
//  ErrorView.swift
//  Coolvert
//
//  Created by Alysson Reis on 21/06/2024.
//

import SwiftUI

struct ErrorView: View {
    let errorMessage: String
    let retryAction: () -> Void

    var body: some View {
        VStack {
            Text("Ocorreu um erro:")
                .font(.headline)
                .padding(.bottom, 10)

            Text(errorMessage)
                .foregroundColor(.red)
                .padding(.bottom, 20)

            Button(action: retryAction) {
                Text("Tentar novamente")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 10)
    }
}

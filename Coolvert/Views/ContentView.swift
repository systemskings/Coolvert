//
//  ContentView.swift
//  Coolvert
//
//  Created by Alysson Reis on 10/05/2024.
//

import SwiftUI
import Firebase

struct ContentView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String = ""
    
    var body: some View {
        BackgroundView {
            VStack {
                Spacer()
                
                // App Title
                Text("Coolvert")
                    .foregroundColor(Color.color9)
                    .font(.custom("Roboto-Thin", size: 48))
                    .padding(.bottom, 20)
                
                // Logo
                Image("Logo1")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 260, height: 260)
                    .padding(.bottom, 10)
                
                
                // Email TextField
                TextField("Digite seu E-mail", text: $email)
                    .padding()
                    .background(Color.color2)
                    .cornerRadius(8)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.color9, lineWidth: 0.3))
                    .padding(.horizontal)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                
                // Password SecureField
                SecureField("Digite sua senha", text: $password)
                    .padding()
                    .background(Color.color2)
                    .cornerRadius(8)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.color9, lineWidth: 0.3))
                    .padding(.horizontal)
                
                // Login Button
                Button(action: {
                    signIn()
                }) {
                    Text("Entrar")
                        .frame(maxWidth: 260)
                        .padding()
                        .background(Color.color2)
                        .foregroundColor(Color.color9)
                        .cornerRadius(50)
                }
                .padding(.horizontal)
                .padding(.top, 40)
                
                // Login with Gmail Button
                Button(action: {
                    // Add Google Sign-In logic here
                }) {
                    HStack {
                        Image(systemName: "globe") // Placeholder for Google logo
                            .foregroundColor(Color.color9)
                        Text("Entre com Gmail")
                            .foregroundColor(Color.color9)
                    }
                    .frame(maxWidth: 260)
                    .padding()
                    .background(Color.color2)
                    .cornerRadius(50)
                }
                .padding(.horizontal)

                
                // Error Message
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
                
                Spacer()
                
                // Bottom Links
                HStack {
                    Button(action: {
                        // Add forgot password logic here
                    }) {
                        Text("Esqueceu sua senha?")
                            .foregroundColor(Color.color9)
                    }
                    
                    Spacer()
                    
                    NavigationLink(destination: SignUpView()) {
                            Text("Cadastre-se")
                                .foregroundColor(Color.color9)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
            .padding()
        }
    }
    
    func signIn() {
        Auth.auth().signIn(withEmail: email.lowercased(), password: password) { authResult, error in
            if let error = error {
                errorMessage = error.localizedDescription
            } else {
                errorMessage = "Login bem-sucedido!"
                // Aqui você pode redirecionar para a próxima tela ou realizar outras ações após o login bem-sucedido
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//
//  ContentView.swift
//  Coolvert
//
//  Created by Alysson Reis on 10/05/2024.
//


import SwiftUI
import GoogleSignIn
import GoogleSignInSwift

struct ContentView: View {
    @StateObject private var viewModel = AuthenticationViewModel()
    
    var body: some View {
        BackgroundView {
            VStack {
                Spacer()
                
                Text("Coolvert")
                    .foregroundColor(Color.color9)
                    .font(.custom("Roboto-Thin", size: 48))
                    .padding(.bottom, 20)
                
                Image("Logo1")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 260, height: 260)
                    .padding(.bottom, 10)
                

                // Email TextField
                FloatingPlaceholderTextField(text: $viewModel.email, placeholder: "Email")
                                
                // Password SecureField
                FloatingPlaceholderTextField(text: $viewModel.password, placeholder: "Senha")
                                
                
                // Login Button
                                Button(action: {
                                    viewModel.signIn()
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
                
                // Login with Google Button
                Button(action: {
                    viewModel.signInWithGoogle()
                    viewModel.showAdditionalInfoView = true
                }){
                    HStack {
                            Image("google") // Substitua "google" pelo nome da sua imagem
                                .resizable()
                                .frame(width: 30, height: 30)
                            Text("Entrar com Google")
                        }
                        .frame(maxWidth: 260)
                        .padding(.vertical, 10)
                        .padding(.horizontal)
                        .background(Color.color2)
                        .foregroundColor(Color.color9)
                        .cornerRadius(50)
                    }
                    .padding(.horizontal)

                
                Text(viewModel.errorMessage)
                    .foregroundColor(.red)
                    .padding()
                
                Spacer()
                
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
        
        VStack {
            if viewModel.isSignedIn {
                if viewModel.showAdditionalInfoView {
                    if let user = viewModel.user {
                        AdditionalInfoView(user: user)
                    }
                } else {
                    Text("Usuário logado!")
                }
            } else {
                Button(action: {
                    viewModel.signInWithGoogle()
                    viewModel.showAdditionalInfoView = true
                }){
                    Text("Entrar com Google")
                        .frame(maxWidth: 260)
                        .padding()
                        .background(Color.color2)
                        .foregroundColor(Color.color9)
                        .cornerRadius(50)
                }
                .padding(.horizontal)
                    
            }
        }
        .padding()
    }
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

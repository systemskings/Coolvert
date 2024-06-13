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
    @StateObject private var additionalInfoViewModel = AdditionalInfoViewModel()
    @State private var email: String = ""
    @State private var errorMessage: String = ""
    
    var body: some View {
        ZStack {
            Group {
                if viewModel.isSignedIn {
                    if viewModel.showAdditionalInfoView {
                        if let userProfile = viewModel.userProfile {
                            AdditionalInfoView(user: userProfile)
                                .environmentObject(additionalInfoViewModel)
                        }
                    } else {
                        if let userProfile = viewModel.userProfile {
                            HomeView(user: userProfile)
                                .environmentObject(viewModel)
                        } else {
                            Text("Carregando dados do usuário...")
                        }
                    }
                } else {
                    loginView
                }
            }
            .environmentObject(viewModel)
            
            if viewModel.isLoading {
                LoadingView()
            }
        }
    }
    
    private var loginView: some View {
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
                        Image("google")
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
                        viewModel.sendPasswordReset()
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

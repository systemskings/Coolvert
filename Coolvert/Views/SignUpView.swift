//
//  SignUpView.swift
//  Coolvert
//
//  Created by Alysson Reis on 20/05/2024.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth

struct SignUpView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String = ""
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    class AppDelegate: NSObject, UIApplicationDelegate {
        func application(_ application: UIApplication,
                         didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
            FirebaseApp.configure()
            
            return true
        }
    }
    
    var body: some View {
        BackgroundView {
            VStack {
                // Nome
                TextField("Nome", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                    .padding()
                
                // CPF / CNPJ
                TextField("CPF / CNPJ", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                    .padding()
                
                // Email
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                    .padding()
                
                // Senha
                SecureField("Senha", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                    .padding()
                
                // Confirmar senhar
                SecureField("Confirme a Senha", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                    .padding()
                
                HStack {

                                Button(action: {
                                    signUp()
                                }) {
                                    Text("Cadastrar")
                                        .padding()
                                        .frame(maxWidth: 260)
                                        .foregroundColor(Color.color9)
                                        .background(Color.color2)
                                        .cornerRadius(50)
                                }
                                .padding()
                            }
                
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
            .padding()
        }
    }
    
    func signUp() {
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                errorMessage = error.localizedDescription
            } else {
                errorMessage = "Usuário cadastrado com sucesso!"
                email = ""
                password = ""
            }
        }
    }
}

#Preview {
    SignUpView()
}

//
//  LoginView.swift
//  Coolvert
//
//  Created by Alysson Reis on 14/05/2024.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth

struct LoginView: View {
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
        VStack {
            Text("Coolvert")
                .padding()
            
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                .padding()
            
            SecureField("Senha", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                .padding()
            
            HStack {
                            Button(action: {
                                signIn()
                            }) {
                                Text("Login")
                                    .padding()
                                    .frame(minWidth: 0, maxWidth: .infinity)
                                    .foregroundColor(.white)
                                    .background(Color("Color1"))
                                    .cornerRadius(8)
                            }
                            .padding()

                            Button(action: {
                                signUp()
                            }) {
                                Text("Cadastrar")
                                    .padding()
                                    .frame(minWidth: 0, maxWidth: .infinity)
                                    .foregroundColor(.white)
                                    .background(Color("Color2"))
                                    .cornerRadius(8)
                            }
                            .padding()
                        }
            
            Text(errorMessage)
                .foregroundColor(.red)
                .padding()
        }
        .padding()
    }
    
    func signIn() {
		
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                errorMessage = error.localizedDescription
            } else {
                errorMessage = "Login bem-sucedido!" + (authResult?.user.uid)!
                
                
                email = ""
                password = ""
                
            }
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
    
    struct LoginView_Previews: PreviewProvider {
		static var previews: some View {
			LoginView()
		}
    }
}

#Preview {
	LoginView()
}

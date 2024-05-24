//
//  ContentView.swift
//  Coolvert
//
//  Created by Alysson Reis on 10/05/2024.
//

import SwiftUI
import Firebase
import FirebaseCore
import GoogleSignIn


//@UIApplicationMain
//class AppDelegate: UIResponder, UIApplicationDelegate {
//
//    var window: UIWindow?
//
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        FirebaseApp.configure()
//        
//        GIDSignIn.sharedInstance.clientID = FirebaseApp.app()?.options.clientID
//        GIDSignIn.sharedInstance.delegate = self
//
//        
//        return true
//    }
//
//    @available(iOS 9.0, *)
//    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
//        return GIDSignIn.sharedInstance.handle(url)
//    }
//}
//
//extension AppDelegate: GIDSignInDelegate {
//    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
//        if let error = error {
//            print("Error signing in: \(error.localizedDescription)")
//            return
//        }
//
//        guard let authentication = user.authentication else { return }
//        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
//
//        Auth.auth().signIn(with: credential) { (authResult, error) in
//            if let error = error {
//                print("Firebase sign-in error: \(error.localizedDescription)")
//            } else {
//                print("User is signed in with Google")
//            }
//        }
//    }
//}

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
                   // signInWithGoogle()
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
    
    
//    func signInWithGoogle() {
//        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
//        
//        let signInConfig = GIDConfiguration(clientID: clientID)
//        
//        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: getRootViewController()) { user, error in
//            if let error = error {
//                errorMessage = error.localizedDescription
//                return
//            }
//            
//            guard let authentication = user?.authentication, let idToken = authentication.idToken else { return }
//            
//            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)
//            
//            Auth.auth().signIn(with: credential) { authResult, error in
//                if let error = error {
//                    errorMessage = error.localizedDescription
//                } else {
//                    errorMessage = "User signed in with Google!"
//                }
//            }
//        }
//    }
//    
//    func getRootViewController() -> UIViewController {
//        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
//            return UIViewController()
//        }
//        guard let rootViewController = screen.windows.first?.rootViewController else {
//            return UIViewController()
//        }
//        return rootViewController
//    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

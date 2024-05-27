//
//  TestGoogleSignIn.swift
//  Coolvert
//
//  Created by Alysson Reis on 25/05/2024.
//

//import SwiftUI
//import GoogleSignIn
//import FirebaseAuth
//import FirebaseCore
//
//struct TestGoogleSignIn: View {
//    @State private var isSignedIn = false
//
//        var body: some View {
//            VStack {
//                if isSignedIn {
//                    Text("Usuário logado!")
//                } else {
//                    Button(action: {
//                        
//                    }) {
//                        HStack {
//                            Image(systemName: "globe") // Placeholder for Google logo
//                                .foregroundColor(.white)
//                            Text("Login com Google")
//                                .foregroundColor(.white)
//                        }
//                        .frame(maxWidth: 260)
//                        .padding()
//                        .background(Color.blue)
//                        .cornerRadius(50)
//                    }
//                    .padding(.horizontal)
//                }
//            }
//        }
//
//        func signInWithGoogle() {
//            guard let clientID = FirebaseApp.app()?.options.clientID else { return }
//            
//
//            let config = GIDConfiguration(clientID: clientID)
//            GIDSignIn.sharedInstance.signIn(withPresenting: getRootViewController()) { authentication, error in
//                    if let error = error {
//                        print("There is an error signing the user in ==> \(error)")
//                        return
//                    }
//
//                guard let user = authentication?.user, let idToken = user.idToken?.tokenString else { return }
//                        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
//
//                Auth.auth().signIn(with: credential) { authResult, error in
//                    if let error = error {
//                        print("Erro ao autenticar com Firebase: \(error.localizedDescription)")
//                        return
//                    }
//                    isSignedIn = true
//                    print("Usuário autenticado com sucesso!")
//                }
//            }
//        }
//
//        func getRootViewController() -> UIViewController {
//            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
//                  let rootViewController = windowScene.windows.first?.rootViewController else {
//                return UIViewController()
//            }
//            return rootViewController
//        }
//    }

//
//  AuthenticationViewModel.swift
//  Coolvert
//
//  Created by Alysson Reis on 03/06/2024.
//

import Foundation
import Firebase
import GoogleSignIn
import GoogleSignInSwift

class AuthenticationViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String = ""
    @Published var isSignedIn: Bool = false
    @Published var showAdditionalInfoView: Bool = false
    @Published var user: User?
    
    private let firebaseAuth = FirebaseAuthActions()
    private let firestoreActions = FirestoreActions()
    
    func signIn() {
        firebaseAuth.signIn(withEmail: email.lowercased(), password: password) { result in
            switch result {
            case .success:
                self.errorMessage = "Login bem-sucedido!"
                self.isSignedIn = true
                self.user = self.firebaseAuth.getUser()
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    func signInWithGoogle() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        _ = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.signIn(withPresenting: getRootViewController()) { authentication, error in
            if let error = error {
                print("There is an error signing the user in ==> \(error)")
                return
            }

            guard let user = authentication?.user, let idToken = user.idToken?.tokenString else { return }
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)

            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print("Erro ao autenticar com Firebase: \(error.localizedDescription)")
                    return
                }
                self.isSignedIn = true
                print("Usuário autenticado com sucesso!")
                
                if let user = Auth.auth().currentUser {
                    self.user = user
                    self.saveUserData(uid: user.uid, name: user.displayName ?? "No Name", email: user.email ?? "No Email")
                    self.showAdditionalInfoView = true
                }
            }
        }
    }
    
    func saveUserData(uid: String, name: String, email: String) {
        let db = Firestore.firestore()
        let userData: [String: Any] = [
            "name": name,
            "email": email,
        ]

        db.collection("users").document(uid).setData(userData) { error in
            if let error = error {
                print("Erro ao salvar os dados do usuário: \(error.localizedDescription)")
            } else {
                print("Dados do usuário salvos com sucesso!")
            }
        }
    }
    
    private func getRootViewController() -> UIViewController {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else {
            return UIViewController()
        }
        return rootViewController
    }
}

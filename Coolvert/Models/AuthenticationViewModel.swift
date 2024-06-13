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
    @Published var userProfile: UserProfile? = nil
    @Published var isLoading: Bool = false
    
    init() {
        checkUserStatus()
    }
    
    func checkUserStatus() {
        if let currentUser = Auth.auth().currentUser {
            fetchUserProfile(uid: currentUser.uid)
        } else {
            self.isSignedIn = false
        }
    }
    
    
    private let firebaseAuth = FirebaseAuthActions()
    private let firestoreActions = FirestoreActions()
    
    
    func signIn() {
        isLoading = true
        firebaseAuth.signIn(withEmail: email.lowercased(), password: password) { [self] result in
            self.isLoading = false
            switch result {
            case .success(let user):
                self.fetchUserProfile(uid: user.uid)
                self.isSignedIn = true
                self.errorMessage = "Login bem-sucedido!"
            case .failure(let error):
                
                errorMessage = error.localizedDescription
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
            
            self.isLoading = true
            Auth.auth().signIn(with: credential) { authResult, error in
                self.isLoading = false
                if let error = error {
                    print("Erro ao autenticar com Firebase: \(error.localizedDescription)")
                    return
                }
                self.isSignedIn = true
                print("Usuário autenticado com sucesso!")
                
                if let user = Auth.auth().currentUser {
                    self.saveUserData(uid: user.uid, name: user.displayName ?? "No Name", email: user.email ?? "No Email", userType: nil)
                    self.showAdditionalInfoView = true
                }
            }
        }
    }
    
    func saveUserData(uid: String, name: String, email: String, userType: Int?) {
        let db = Firestore.firestore()
        var userData: [String: Any] = [
            "name": name,
            "email": email
        ]
        
        if let userType = userType {
            userData["userType"] = userType
        }
        
        db.collection("users").document(uid).setData(userData) { error in
            if let error = error {
                print("Erro ao salvar os dados do usuário: \(error.localizedDescription)")
            } else {
                print("Dados do usuário salvos com sucesso!")
            }
        }
    }
    
    func fetchUserProfile(uid: String) {
        let db = Firestore.firestore()
        db.collection("users").document(uid).getDocument { document, error in
            if let document = document, document.exists {
                let data = document.data() ?? [:]
                self.userProfile = UserProfile(uid: uid, data: data)
                self.isSignedIn = true
            } else {
                print("Documento do usuário não encontrado: \(error?.localizedDescription ?? "Erro desconhecido")")
            }
        }
    }
    
    func sendPasswordReset() {
        guard !email.isEmpty else {
            errorMessage = "Por favor, insira seu e-mail."
            return
        }
        
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                self.errorMessage = "Erro ao enviar e-mail de redefinição de senha: \(error.localizedDescription)"
            } else {
                self.errorMessage = "E-mail de redefinição de senha enviado com sucesso!"
            }
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.isSignedIn = false
            self.userProfile = nil
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
            self.errorMessage = "Erro ao sair: \(signOutError.localizedDescription)"
        }
    }
    
    private func getRootViewController() -> UIViewController {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return UIViewController()
        }
        guard let root = screen.windows.first?.rootViewController else {
            return UIViewController()
        }
        return root
    }
    
}

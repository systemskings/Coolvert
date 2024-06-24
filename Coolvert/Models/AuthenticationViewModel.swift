//
//  AuthenticationViewModel.swift
//  Coolvert
//
//  Created by Alysson Reis on 03/06/2024.
//

import Foundation
import Firebase
import GoogleSignIn

enum ViewState {
    case loading
    case signedIn(UserProfile)
    case showAdditionalInfo(UserProfile)
    case error(String)
    case login
}

class AuthenticationViewModel: ObservableObject {
    
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String = ""
    @Published var isSignedIn: Bool = false
    @Published var showAdditionalInfoView: Bool = false
    @Published var userProfile: UserProfile? = nil
    @Published var isLoading: Bool = false
    @Published var viewState: ViewState = .login
    
    
    init() {
        checkUserStatus()
    }
    
    func checkUserStatus() {
        if let currentUser = Auth.auth().currentUser {
            loadUserProfile(uid: currentUser.uid) { [weak self] userProfile in
                guard let self = self else { return }
                if userProfile.requiresAdditionalInfo == true {
                    self.viewState = .showAdditionalInfo(userProfile)
                } else {
                    self.viewState = .signedIn(userProfile)
                }
            }
        } else {
            self.isSignedIn = false
            self.viewState = .login
        }
    }
    
    
    private let firebaseAuth = FirebaseAuthActions()
    private let firestoreActions = FirestoreActions()
    
    
    func signIn() {
        isLoading = true
        viewState = .loading
        firebaseAuth.signIn(withEmail: email.lowercased(), password: password) { [weak self] result in
            guard let self = self else { return }
            
            self.isLoading = false
            
            switch result {
            case .success(let user):
                self.loadUserProfile(uid: user.uid) { userProfile in
                    if userProfile.requiresAdditionalInfo {
                        self.viewState = .showAdditionalInfo(userProfile)
                    } else {
                        self.viewState = .signedIn(userProfile)
                    }
                }
            case .failure(let error):
                self.errorMessage = error.localizedDescription
                self.viewState = .error(error.localizedDescription)
            }
        }
    }
    
    
    func signInWithGoogle() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: getRootViewController()) { authentication, error in
            if let error = error {
                print("There is an error signing the user in ==> \(error)")
                self.viewState = .error(error.localizedDescription)
                return
            }
            
            guard let user = authentication?.user,
                  let idToken = user.idToken?.tokenString
            else { return }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
            
            self.isLoading = true
            Auth.auth().signIn(with: credential) { authentication, error in
                self.isLoading = false
                if let error = error {
                    print("Erro ao autenticar com Firebase: \(error.localizedDescription)")
                    self.viewState = .error(error.localizedDescription)
                    return
                }
                self.isSignedIn = true
                print("Usuário autenticado com sucesso!")
                
                if let currentUser = Auth.auth().currentUser {
                    let uid = currentUser.uid
                    let name = currentUser.displayName ?? "No Name"
                    let email = currentUser.email ?? "No Email"
                    
                    self.checkUserExists(uid: uid) { exists in
                        if exists {
                            self.loadUserProfile(uid: uid) { userProfile in
                                if userProfile.requiresAdditionalInfo {
                                    self.viewState = .showAdditionalInfo(userProfile)
                                } else {
                                    self.viewState = .signedIn(userProfile)
                                }
                            }
                        } else {
                            self.saveUserData(uid: uid, name: name, email: email, userType: nil) {
                                self.loadUserProfile(uid: uid) { userProfile in
                                    if userProfile.requiresAdditionalInfo {
                                        self.viewState = .showAdditionalInfo(userProfile)
                                    } else {
                                        self.viewState = .signedIn(userProfile)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    
    private func saveUserData(uid: String, name: String, email: String, userType: Int?, completion: @escaping () -> Void) {
        let db = Firestore.firestore()
        var userData: [String: Any] = [
            "name": name,
            "email": email,
            "createdAt": FieldValue.serverTimestamp(),
            "requiresAdditionalInfo": true // Defina como true durante o primeiro login
        ]
        
        if let userType = userType {
                userData["userType"] = userType
            }
        
        db.collection("users").document(uid).setData(userData) { error in
            if let error = error {
                print("Erro ao salvar os dados do usuário: \(error.localizedDescription)")
                self.viewState = .error(error.localizedDescription)
            } else {
                print("Dados do usuário salvos com sucesso!")
                completion()
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
                self.viewState = .error(error.localizedDescription)
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
            self.viewState = .login
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
            self.errorMessage = "Erro ao sair: \(signOutError.localizedDescription)"
            self.viewState = .error(signOutError.localizedDescription)
        }
    }
    
    func loadUserProfile(uid: String, completion: @escaping (UserProfile) -> Void) {
        let db = Firestore.firestore()
        db.collection("users").document(uid).getDocument { [weak self] document, error in
            guard let self = self else { return }
            self.isLoading = false
            if let error = error {
                self.errorMessage = "Erro ao carregar perfil do usuário: \(error.localizedDescription)"
                self.viewState = .error(error.localizedDescription)
                return
            }
            if let document = document, document.exists {
                guard let data = document.data() else {
                    self.errorMessage = "Documento do perfil do usuário não encontrado."
                    self.viewState = .error("Documento do perfil do usuário não encontrado.")
                    return
                }
                let userProfile = UserProfile(uid: uid, data: data)
                self.userProfile = userProfile
                self.errorMessage = ""
                completion(userProfile)
                print("Perfil do usuário carregado com sucesso!")
            } else {
                self.errorMessage = "Documento do perfil do usuário não encontrado."
                self.viewState = .error("Documento do perfil do usuário não encontrado.")
            }
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

private func checkUserExists(uid: String, completion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()
        db.collection("users").document(uid).getDocument { document, error in
            if let document = document, document.exists {
                completion(true)
            } else {
                completion(false)
            }
        }
    }

}

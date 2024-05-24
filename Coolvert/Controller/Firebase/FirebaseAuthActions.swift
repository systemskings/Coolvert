import Foundation

import FirebaseAuth

class FirebaseAuthActions {
        
    private let firebaseAuth = Auth.auth()
    
    func signIn(withEmail email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        firebaseAuth.signIn(withEmail: email, password: password) { authResult, error in
            if let authResult = authResult {
                completion(.success(authResult.user))
            } else if let error = error {
                // teste commit
                completion(.failure(error))
            }
        }
    }
    
    func singOut () -> String {
        if firebaseAuth.currentUser != nil {
            do {
                try firebaseAuth.signOut()
                return "Feito!"
            } catch let error {
                return "Erro: \(error.localizedDescription)"
            }
        } else {
            return "Nenhum usuário logado."
        }
    }
    
    func signUp(withEmail email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        firebaseAuth.createUser(withEmail: email, password: password) { authResult, error in
            if let authResult = authResult {
                completion(.success(authResult.user))
            } else if let error = error {
                completion(.failure(error))
            }
        }
    }
    
    func getUser() -> User? {
        return Auth.auth().currentUser
    }
}

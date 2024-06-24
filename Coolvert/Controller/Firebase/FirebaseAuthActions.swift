import Firebase
import GoogleSignIn
import FirebaseAuth
import FirebaseFirestore

class FirebaseAuthActions {
    
    private let firebaseAuth = Auth.auth()
    
    struct EmailNotVerifiedError: Error {
        var localizedDescription: String {
            return "O e-mail ainda não foi verificado."
        }
    }
    
    func signIn(withEmail email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        firebaseAuth.signIn(withEmail: email, password: password) { authResult, error in
            if let authResult = authResult {
                if authResult.user.isEmailVerified {
                    completion(.success(authResult.user))
                } else {
                    self.signOut()
                    completion(.failure(CustomErrors.emailNotVerified))
                }
            } else if let error = error {
                completion(.failure(error))
            }
        }
    }
    
    func signOut() {
        if firebaseAuth.currentUser != nil {
            do {
                try firebaseAuth.signOut()
            } catch {
                print("Erro ao sair: \(error.localizedDescription)")
            }
        }
    }
    
    func signUp(withEmail email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        firebaseAuth.createUser(withEmail: email, password: password) { authResult, error in
            if let authResult = authResult {
                authResult.user.sendEmailVerification { error in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(authResult.user))
                    }
                }
            } else if let error = error {
                completion(.failure(error))
            }
        }
    }
    
    func getUser() -> User? {
        return Auth.auth().currentUser
    }
}

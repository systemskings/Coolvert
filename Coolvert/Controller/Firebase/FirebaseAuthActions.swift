import Foundation

import FirebaseAuth

class FirebaseAuthActions {
    
    private let firebaseAuth = Auth.auth()
    
    struct EmailNotVerifiedError: Error {
        var localizedDescription: String {
            return "O e-mail ainda não foi verificado."
        }
    }
    
    
    func signIn(withEmail email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        firebaseAuth.signIn(withEmail: email, password: password) { authResult, error in
            if authResult != nil {
                
                if let authUser = authResult?.user {
                    
                    if authUser.isEmailVerified {
                        completion(.success(authUser))
                    } else {
                        self.singOut()
                        completion(.failure(CustomErrors.emailNotVerified))
                    }
                }
                
            } else if let error = error {
                completion(.failure(error))
            }
        }
    }
    
    func singOut () {
        if firebaseAuth.currentUser != nil {
            do {
                try firebaseAuth.signOut()
                
            } catch _ {}
        }
    }
    
    func signUp(withEmail email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        firebaseAuth.createUser(withEmail: email, password: password) { authResult, error in
            if let authResult = authResult {
                authResult.user.sendEmailVerification()
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

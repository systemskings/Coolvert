import Foundation
import FirebaseAuth
import FirebaseFirestore

class SignUpViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var cpfCnpj: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var errorMessage: String = ""
    @Published var isCheckedEmpresa: Bool = false
    @Published var isCheckedArtista: Bool = false
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    @Published var navigateToLogin: Bool = false
    
    private let firebaseAuth = FirebaseAuthActions()
    private let firestoreActions = FirestoreActions()
    
    func signUp() {
        guard !name.isEmpty, !cpfCnpj.isEmpty, !email.isEmpty, !password.isEmpty, !confirmPassword.isEmpty else {
            errorMessage = "Por favor, preencha todos os campos."
            return
        }
        
        guard password == confirmPassword else {
            errorMessage = "As senhas não coincidem."
            return
        }
        
        guard isCheckedArtista == true && isCheckedEmpresa == false || isCheckedArtista == false && isCheckedEmpresa == true else {
            errorMessage = "Você é uma Empresa ou um Artista?"
            return
        }
        
        let userType = isCheckedEmpresa ? 0 : 1
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
                return
            }
            
            guard let user = authResult?.user else {
                self.errorMessage = "Erro ao criar usuário."
                return
            }
            
            user.sendEmailVerification { error in
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    return
                }
                self.alertMessage = "Um e-mail de verificação foi enviado para \(self.email). Por favor, verifique sua caixa de entrada."
                self.showAlert = true
                self.saveUserData(uid: user.uid, userType: userType)
            }
        }
    }
    
    func saveUserData(uid: String, userType: Int) {
        let db = Firestore.firestore()
        let userData: [String: Any] = [
            FirestoreKeys.field_users_name.rawValue: name,
            FirestoreKeys.field_users_email.rawValue: email,
            FirestoreKeys.field_users_cpfcnpj.rawValue: cpfCnpj,
            FirestoreKeys.field_users_usertype.rawValue: userType,
            "createdAt": FieldValue.serverTimestamp(),
            FirestoreKeys.field_users_requires_additional_info.rawValue: false
        ]
        
        db.collection("users").document(uid).setData(userData) { error in
            if let error = error {
                self.errorMessage = "Erro ao salvar os dados do usuário: \(error.localizedDescription)"
            } else {
                self.clearFields()
                DispatchQueue.main.async {
                    self.navigateToLogin = true
                }
            }
        }
    }
    
    private func clearFields() {
        email = ""
        password = ""
        confirmPassword = ""
        name = ""
        cpfCnpj = ""
        isCheckedEmpresa = false
        isCheckedArtista = false
    }
}

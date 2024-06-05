//
//  SignUpViewModel.swift
//  Coolvert
//
//  Created by Alysson Reis on 03/06/2024.
//

import Foundation
import Firebase
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
        
        firebaseAuth.signUp(withEmail: email, password: password) { result in
            switch result {
            case .success(let user):
                self.saveUserData(uid: user.uid, userType: userType)
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    func saveUserData(uid: String, userType: Int) {
        firestoreActions.uploadDataUser(uid: uid, email: email, name: name, cpfCnpj: cpfCnpj, userType: userType) { result in
            switch result {
            case .success:
                self.errorMessage = "Usuário cadastrado com sucesso!"
                self.clearFields()
            case .failure(let error):
                self.errorMessage = "Erro ao salvar os dados do usuário: \(error.localizedDescription)"
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


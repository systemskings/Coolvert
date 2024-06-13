//
//  AdditionalInfoViewModel.swift
//  Coolvert
//
//  Created by Alysson Reis on 03/06/2024.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class AdditionalInfoViewModel: ObservableObject {
    @Published var cpfCnpj: String = ""
    @Published var errorMessage: String = ""
    @Published var isCheckedEmpresa: Bool = false
    @Published var isCheckedArtista: Bool = false
    
    
    func saveAdditionalUserData(user: UserProfile) {
        guard !cpfCnpj.isEmpty else {
            errorMessage = "Por favor, preencha todos os campos."
            return
        }
        
        guard isCheckedArtista == true && isCheckedEmpresa == false || isCheckedArtista == false && isCheckedEmpresa == true else {
            errorMessage = "Você é uma Empresa ou um Artista?"
            return
        }
        
        let userType = isCheckedEmpresa ? 0 : 1
        let db = Firestore.firestore()
        let userData: [String: Any] = [
            "cpfCnpj": cpfCnpj,
            "userType": userType,
            "createdAt": FieldValue.serverTimestamp()
        ]

        db.collection("users").document(user.uid).setData(userData) { error in
            if let error = error {
                self.errorMessage = "Erro ao salvar os dados do usuário: \(error.localizedDescription)"
            } else {
                self.errorMessage = "Dados do usuário salvos com sucesso!"
            }
        }
    }
}

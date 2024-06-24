import Foundation
import FirebaseFirestore
import FirebaseAuth

enum UserType: Int {
    case empresa = 0
    case artista = 1
}

class AdditionalInfoViewModel: ObservableObject {
    @Published var cpfCnpj: String = ""
    @Published var errorMessage: String = ""
    @Published var isCheckedEmpresa: Bool = false
    @Published var isCheckedArtista: Bool = false

    func saveAdditionalUserData(user: UserProfile, completion: @escaping (Bool) -> Void) {
        guard !cpfCnpj.isEmpty else {
            errorMessage = "Por favor, preencha todos os campos."
            completion(false)
            return
        }

        guard isCheckedArtista == true && isCheckedEmpresa == false || isCheckedArtista == false && isCheckedEmpresa == true else {
            errorMessage = "Você é uma Empresa ou um Artista?"
            completion(false)
            return
        }

        let userType = isCheckedEmpresa ? UserType.empresa.rawValue : UserType.artista.rawValue
        let db = Firestore.firestore()
        let userData: [String: Any] = [
            "cpfCnpj": cpfCnpj,
            "userType": userType,
            "createdAt": FieldValue.serverTimestamp(),
            "requiresAdditionalInfo": false
        ]

        db.collection("users").document(user.uid).updateData(userData) { error in
            if let error = error {
                self.errorMessage = "Erro ao salvar os dados do usuário: \(error.localizedDescription)"
                completion(false)
            } else {
                self.errorMessage = "Dados do usuário salvos com sucesso!"
                completion(true)
            }
        }
    }
}

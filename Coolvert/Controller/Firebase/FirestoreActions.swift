import Foundation
import FirebaseFirestore

class FirestoreActions {
    
    let firestore = Firestore.firestore()
    
    func uploadDataUser(uid: String, email: String, name: String, cpfCnpj: String, userType: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        let dataUser: [String: Any] = [
            FirestoreKeys.field_users_email.rawValue: email,
            FirestoreKeys.field_users_name.rawValue: name,
            FirestoreKeys.field_users_cpfcnpj.rawValue: cpfCnpj,
            FirestoreKeys.field_users_usertype.rawValue: userType,
           // "requiresAdditionalInfo": true
        ]
        
        firestore.collection(FirestoreKeys.table_users.rawValue)
            .document(uid)
            .setData(dataUser) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
    }
    
    func updateUserField(uid: String, value: Any, field: String) {
        firestore.collection(FirestoreKeys.table_users.rawValue)
            .document(uid)
            .updateData([field: value]) { error in
                if let error = error {
                    print("Erro ao atualizar o campo \(field): \(error.localizedDescription)")
                } else {
                    print("Campo \(field) atualizado com sucesso!")
                }
            }
    }
}

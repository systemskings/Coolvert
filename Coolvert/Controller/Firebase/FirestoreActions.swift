import Foundation
import Firebase
import FirebaseFirestore

class FirestoreActions {
        
    let firestore = Firestore.firestore()
    
    func uploadDataUser( uid: String, email: String, name: String, cpfCnpj: String) {
        
        let dataUser: [String : Any] = [
            "email " : email,
            "name" : name,
            "cpfCnpj" : cpfCnpj
        ]
        
        firestore.collection("users")
            .document(uid)
            .setData(dataUser)
    }
    
}


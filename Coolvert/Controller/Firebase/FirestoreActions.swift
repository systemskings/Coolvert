import Foundation
import Firebase
import FirebaseFirestore

class FirestoreActions {
    let firestore = Firestore.firestore()
    
    func cadastrarUsuario( nome: String, ) {
        let dados: [String : Any] = [ "idade" : 21 , "nome " : "joao" ]
        firestore.collection("usuarios").document("jpreis").setData(dados)
    }
    
}


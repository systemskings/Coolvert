//
//  UseerProfile.swift
//  Coolvert
//
//  Created by Alysson Reis on 10/06/2024.
//

import FirebaseFirestore

struct UserProfile {
    let uid: String
    let name: String
    let email: String
    let userType: Int
    
    init(uid: String, data: [String: Any]) {
        self.uid = uid
        self.name = data["name"] as? String ?? ""
        self.email = data["email"] as? String ?? ""
        self.userType = data[FirestoreKeys.field_users_usertype.rawValue] as? Int ?? -1
    }
    
    var clientTypeDescription: String {
        switch self.userType {
        case 0:
            return "Empresa"
        case 1:
            return "Artista"
        default:
            return "Desconhecido"
        }
    }
}

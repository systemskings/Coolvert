//
//  UseerProfile.swift
//  Coolvert
//
//  Created by Alysson Reis on 10/06/2024.
//

import FirebaseFirestore

struct UserProfile: Codable {
    let uid: String
    let name: String
    let email: String
    let userType: Int?
    let requiresAdditionalInfo: Bool
    
    init(uid: String, data: [String: Any]) {
        self.uid = uid
        self.name = data["name"] as? String ?? ""
        self.email = data["email"] as? String ?? ""
        self.userType = data["userType"] as? Int ?? -1
        self.requiresAdditionalInfo = data["requiresAdditionalInfo"] as? Bool ?? false
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


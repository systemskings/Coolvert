//
//  UserModel.swift
//  Coolvert
//
//  Created by Alysson Reis on 26/06/2024.
//

import Foundation
import FirebaseFirestoreSwift

struct UserModel: Identifiable, Codable {
    var id: String? // Id manual, definido ao criar a struct
    var uid: String
    var name: String
    var email: String
    var userType: Int
    var profileImageURL: String?

    var userTypeDescription: String {
        switch userType {
        case 0:
            return "Empresa"
        case 1:
            return "Artista"
        default:
            return "Desconhecido"
        }
    }
}

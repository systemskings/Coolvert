//
//  FirestoreService.swift
//  Coolvert
//
//  Created by Alysson Reis on 26/06/2024.
//

import FirebaseFirestore
import Combine

class FirestoreService: ObservableObject {
    private let db = Firestore.firestore()
    @Published var users: [UserModel] = []

    func fetchUsers(excluding userId: String) {
        db.collection("users").whereField("uid", isNotEqualTo: userId).getDocuments { snapshot, error in
            if let error = error {
                print("Erro ao buscar usuários: \(error.localizedDescription)")
                return
            }

            self.users = snapshot?.documents.compactMap { document -> UserModel? in
                var user = try? document.data(as: UserModel.self)
                user?.id = document.documentID
                return user
            } ?? []
        }
    }
}


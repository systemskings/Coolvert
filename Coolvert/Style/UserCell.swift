//
//  UserCell.swift
//  Coolvert
//
//  Created by Alysson Reis on 26/06/2024.
//

import SwiftUI

struct UserCell: View {
    var user: UserModel

    var body: some View {
        HStack {
            if let imageUrl = user.profileImageURL, let url = URL(string: imageUrl) {
                AsyncImage(url: url) { image in
                    image.resizable()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                } placeholder: {
                    ProgressView()
                }
            } else {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
            }
            VStack(alignment: .leading) {
                Text(user.name)
                    .font(.headline)
                Text(user.userTypeDescription)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
    }
}

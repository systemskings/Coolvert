//
//  AdditionalInfoView.swift
//  Coolvert
//
//  Created by Alysson Reis on 29/05/2024.
//

import SwiftUI
import FirebaseAuth

struct AdditionalInfoView: View {
    @EnvironmentObject var viewModel: AdditionalInfoViewModel
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    
    let user: UserProfile
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    viewModel.isCheckedEmpresa.toggle()
                    viewModel.isCheckedArtista = false
                }) {
                    HStack {
                        Image(viewModel.isCheckedEmpresa ? "martini2" : "martini")
                            .resizable()
                            .frame(width: 50, height: 50)
                        Text("Empresa")
                            .font(.custom("Roboto-Regular", size: 18))
                            .foregroundColor(viewModel.isCheckedEmpresa ? .blue : .black)
                    }
                }
                .padding(.trailing, 80)
                
                Button(action: {
                    viewModel.isCheckedArtista.toggle()
                    viewModel.isCheckedEmpresa = false
                }) {
                    HStack {
                        Image(viewModel.isCheckedArtista ? "microphone2" : "microphone")
                            .resizable()
                            .frame(width: 50, height: 50)
                        Text("Artista")
                            .font(.custom("Roboto-Regular", size: 18))
                            .foregroundColor(viewModel.isCheckedArtista ? .blue : .black)
                    }
                }
                .padding(.vertical)
            }
            .padding()
            
            VStack {
                TextField("CPF/CNPJ", text: $viewModel.cpfCnpj)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button(action: {
                    viewModel.saveAdditionalUserData(user: user) { success in
                        if success {
                            authViewModel.loadUserProfile(uid: user.uid) { updatedUser in
                                authViewModel.viewState = .signedIn(updatedUser)
                            }
                        }
                    }
                }) {
                    Text("Salvar")
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .padding()
                
                Text(viewModel.errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
            .padding()
        }
    }
}



//
//  SignUpView.swift
//  Coolvert
//
//  Created by Alysson Reis on 20/05/2024.
//




import SwiftUI
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

struct SignUpView: View {
    @StateObject private var viewModel = SignUpViewModel()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    class AppDelegate: NSObject, UIApplicationDelegate {
        func application(_ application: UIApplication,
                         didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
            FirebaseApp.configure()
            return true
        }
    }
    
    var body: some View {
        BackgroundView {
            VStack {
                Text("Coolvert")
                    .foregroundColor(Color.color9)
                    .font(.custom("Roboto-Thin", size: 48))
                    .padding(.top, 40)
                
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
                
                
                FloatingPlaceholderTextField(text: $viewModel.name, placeholder: "Nome")
                
                
                FloatingPlaceholderTextField(text: $viewModel.cpfCnpj, placeholder: "CPF / CNPJ")
                
                
                FloatingPlaceholderTextField(text: $viewModel.email, placeholder: "Email")
                
                
                FloatingPlaceholderTextField(text: $viewModel.password, placeholder: "Senha")
                
                
                FloatingPlaceholderTextField(text: $viewModel.confirmPassword, placeholder: "Confirme a Senha")
                
                HStack {
                    Button(action: {
                        viewModel.signUp()
                    }) {
                        Text("Cadastrar")
                            .customButtonStyle()
                    }
                    .padding()
                }
                
                Text(viewModel.errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
            .padding()
        }
    }
}

extension View {
    
    func customButtonStyle() -> some View {
        self
            .padding()
            .frame(maxWidth: 260)
            .foregroundColor(Color.color9)
            .background(Color.color2)
            .cornerRadius(50)
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}

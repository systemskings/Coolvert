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
    @State private var name: String = ""
    @State private var cpfCnpj: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String = ""
    @State private var confirmPassword = ""
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @State private var isCheckedEmpresa: Bool = false
    @State private var isCheckedArtista: Bool = false
    
    private let firebaseAuth = FirebaseAuthActions()
    private let firestore = FirestoreActions()
    
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
                // App Title
                Text("Coolvert")
                    .foregroundColor(Color.color9)
                    .font(.custom("Roboto-Thin", size: 48))
                    .padding(.top, 40)
                
                // Escolha do tipo de usuario
                HStack {
                    Image(isCheckedEmpresa ? "martini2" : "martini")
                        .resizable()
                        .frame(width: 50, height: 50)
                       // .cornerRadius(50)
                       // .background(isCheckedMartini ? Color.color7 : Color.color2)
                        .onTapGesture {
                            isCheckedEmpresa.toggle()
                            isCheckedArtista = false
                        }
                    
                    VStack {
                        Text("Empresa")
                            .font(.custom("Roboto-Regular", size: 18))
                    }
                    .padding(.trailing, 80)
                    
                    
                    Image(isCheckedArtista ? "microphone2" : "microphone")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .onTapGesture {
                            isCheckedArtista.toggle()
                            isCheckedEmpresa = false
                        }
                    VStack {
                        Text("Artista")
                            .font(.custom("Roboto-Regular", size: 18))
                    }
                    .padding(.vertical)
                }
                .padding()
                
                // Nome
                TextField("Nome", text: $name)
                    .padding()
                    .background(Color.color2)
                    .cornerRadius(8)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.color9, lineWidth: 0.3))
                    .padding(.horizontal)
                    .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)

                // CPF / CNPJ
                TextField("CPF / CNPJ", text: $cpfCnpj)
                    .padding()
                    .background(Color.color2)
                    .cornerRadius(8)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.color9, lineWidth: 0.3))
                    .padding(.horizontal)
                    .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)

                // Email
                TextField("Email", text: $email)
                    .padding()
                    .background(Color.color2)
                    .cornerRadius(8)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.color9, lineWidth: 0.3))
                    .padding(.horizontal)
                    .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                
                // Senha
                SecureField("Senha", text: $password)
                    .padding()
                    .background(Color.color2)
                    .cornerRadius(8)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.color9, lineWidth: 0.3))
                    .padding(.horizontal)
                    .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                    .autocorrectionDisabled()
                
                // Confirmar senhar
                SecureField("Confirme a Senha", text: $confirmPassword)
                    .padding()
                    .background(Color.color2)
                    .cornerRadius(8)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.color9, lineWidth: 0.3))
                    .padding(.horizontal)
                    .autocorrectionDisabled()
                    .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                      
                HStack {

                                Button(action: {
                                    signUp()
                                }) {
                                    Text("Cadastrar")
                                        .padding()
                                        .frame(maxWidth: 260)
                                        .foregroundColor(Color.color9)
                                        .background(Color.color2)
                                        .cornerRadius(50)
                                }
                                .padding()
                            }
                
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
            .padding()
        }
    }
    
//    let group = DispatchGroup()
    func validate(completion: @escaping (Bool) -> Void) {
//        group.enter()
//        DispatchQueue.global().async {
            InvertextoAPI.validate(cpfCnpj: cpfCnpj) { result in
                switch result {
                case .success(let result):
                    if(result.0 == false) {
                        errorMessage = "CPF/CNPJ inválido."
                        completion(false)
                    } else {
                        completion(true)
                    }
                case .failure(let error):
                    errorMessage = "Erro API: \(error.localizedDescription)"
                    completion(false)
                }
//                group.leave()
            }
//        }
    }
    
    func signUp() {

        // Verifica se todos os campos estão preenchidos
        guard !name.isEmpty, !cpfCnpj.isEmpty, !email.isEmpty, !password.isEmpty, !confirmPassword.isEmpty else {
            errorMessage = "Por favor, preencha todos os campos."
            return
        }
        
        // Verifica se as senhas coincidem
        guard password == confirmPassword else {
            errorMessage = "As senhas não coincidem."
            return
        }
        
        // Verifica tipo de usuário selecionado
        guard isCheckedArtista == true && isCheckedEmpresa == false || isCheckedArtista == false && isCheckedEmpresa == true else {
            errorMessage = "Você é uma Empresa ou um Artista ?"
            return
        }
        
        let userType = isCheckedEmpresa ? 0 : 1
        
        // Validar CNPJ e CPF
//        validate { result in
//            group.wait()
//            if !result {
//                return
//            }
//        }
        
        // Cria o usuário no Firebase Authentication
        firebaseAuth.signUp(withEmail: email, password: password) { result in
            switch result {
            case .success(let user):
                saveUserData(uid: user.uid, userType: userType)
            case .failure(let error):
                errorMessage = error.localizedDescription
            }
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                errorMessage = error.localizedDescription
            } else {
                guard let uid = authResult?.user.uid else { return }
                saveUserData(uid: uid, userType: userType)
            }
        }
    }
    
    func saveUserData(uid: String, userType: Int) {
        
        firestore.uploadDataUser(uid: uid, email: email, name: name, cpfCnpj: cpfCnpj, userType: userType) { result in
            switch result {
            case .success(()):
                errorMessage = "Usuário cadastrado com sucesso!"
                // Limpa os campos
                email = ""
                password = ""
                confirmPassword = ""
                name = ""
                cpfCnpj = ""
                isCheckedEmpresa = false
                isCheckedArtista = false
            case .failure(let error):
                errorMessage = "Erro ao salvar os dados do usuário: \(error.localizedDescription)"
            }
        }
        
            // Prepara os dados do usuário
//            let userData: [String: Any] = [
//                "name": name,
//                "cpfCnpj": cpfCnpj,
//                "email": email,
//                "userType": userType
//            ]
            // Salva os dados no Firestore
//            let db = Firestore.firestore()
//            db.collection("users").document(uid).setData(userData) { error in
//                if let error = error {
//                    errorMessage = "Erro ao salvar os dados do usuário: \(error.localizedDescription)"
//                } else {
//                    errorMessage = "Usuário cadastrado com sucesso!"
//                    // Limpa os campos
//                    email = ""
//                    password = ""
//                    confirmPassword = ""
//                    name = ""
//                    cpfCnpj = ""
//                    isCheckedEmpresa = false
//                    isCheckedArtista = false
//                }
//            }
        }
    }

#Preview {
    SignUpView()
}

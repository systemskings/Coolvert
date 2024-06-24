import SwiftUI
import FirebaseCore
import FirebaseAuth
import GoogleSignIn



class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        // Configuração do Google Sign-In
                GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
                    if let error = error {
                        print("Erro ao restaurar sessão anterior do Google Sign-In: \(error.localizedDescription)")
                    }
                }
                
                return true
            }
    
    func application(
      _ app: UIApplication,
      open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
      var handled: Bool

      handled = GIDSignIn.sharedInstance.handle(url)
      if handled {
        return true
      }

      // Handle other custom URL types.

      // If not handled by this app, return false.
      return false
    }
}


///////////////////////////////
//
//
//class AuthenticationViewModel: ObservableObject {
//    @Published var email: String = ""
//    @Published var password: String = ""
//    @Published var errorMessage: String = ""
//    @Published var isSignedIn: Bool = false
//    @Published var showAdditionalInfoView: Bool = false
//    @Published var userProfile: UserProfile? = nil
//    @Published var isLoading: Bool = false
//    
//    init() {
//        checkUserStatus()
//    }
//    
//    func checkUserStatus() {
//        if let currentUser = Auth.auth().currentUser {
//            loadUserProfile(uid: currentUser.uid)
//        } else {
//            self.isSignedIn = false
//        }
//    }
//    
//    
//    private let firebaseAuth = FirebaseAuthActions()
//    private let firestoreActions = FirestoreActions()
//    
//    
//    func signIn() {
//        isLoading = true
//        firebaseAuth.signIn(withEmail: email.lowercased(), password: password) { [weak self] (result: Result<User, Error>) in
//            guard let self = self else { return }
//            
//            self.isLoading = false
//            
//            switch result {
//            case .success(let user):
//                self.loadUserProfile(uid: user.uid)
//                self.isSignedIn = true
//                self.errorMessage = "Login bem-sucedido!"
//            case .failure(let error):
//                self.errorMessage = error.localizedDescription
//            }
//        }
//    }
//
//
//    
//    func signInWithGoogle(presentingViewController: UIViewController) {
//            isLoading = true
//            firebaseAuth.signInWithGoogle(presentingViewController: presentingViewController) { [weak self] result in
//                guard let self = self else { return }
//                
//                self.isLoading = false
//                
//                switch result {
//                case .success(let user):
//                    self.isSignedIn = true
//                    self.loadUserProfile(uid: user.uid)
//                    self.showAdditionalInfoView = true
//                    self.errorMessage = "Login com Google bem-sucedido!"
//                case .failure(let error):
//                    self.errorMessage = error.localizedDescription
//                }
//            }
//    }
//    
//    
//    func sendPasswordReset() {
//        guard !email.isEmpty else {
//            errorMessage = "Por favor, insira seu e-mail."
//            return
//        }
//        
//        Auth.auth().sendPasswordReset(withEmail: email) { error in
//            if let error = error {
//                self.errorMessage = "Erro ao enviar e-mail de redefinição de senha: \(error.localizedDescription)"
//            } else {
//                self.errorMessage = "E-mail de redefinição de senha enviado com sucesso!"
//            }
//        }
//    }
//    
//    func signOut() {
//        do {
//            try Auth.auth().signOut()
//            self.isSignedIn = false
//            self.userProfile = nil
//        } catch let signOutError as NSError {
//            print("Error signing out: %@", signOutError)
//            self.errorMessage = "Erro ao sair: \(signOutError.localizedDescription)"
//        }
//    }
//    
//    private func loadUserProfile(uid: String) {
//        let db = Firestore.firestore()
//            db.collection("users").document(uid).getDocument { document, error in
//                if let error = error {
//                    print("Erro ao carregar perfil do usuário: \(error.localizedDescription)")
//                    return
//                }
//
//                if let document = document, document.exists {
//                    do {
//                        let userProfile = try document.data(as: UserProfile.self)
//                        self.userProfile = userProfile
//                        print("Perfil do usuário carregado com sucesso!")
//                    } catch {
//                        print("Erro ao converter documento do Firestore em UserProfile: \(error.localizedDescription)")
//                    }
//                } else {
//                    print("Documento do perfil do usuário não encontrado.")
//                }
//            }
//        }
//    
//    
//    private func getRootViewController() -> UIViewController {
//        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
//            return UIViewController()
//        }
//        guard let root = screen.windows.first?.rootViewController else {
//            return UIViewController()
//        }
//        return root
//    }
//    
//}
//
//
//class SignUpViewModel: ObservableObject {
//    @Published var name: String = ""
//    @Published var cpfCnpj: String = ""
//    @Published var email: String = ""
//    @Published var password: String = ""
//    @Published var confirmPassword: String = ""
//    @Published var errorMessage: String = ""
//    @Published var isCheckedEmpresa: Bool = false
//    @Published var isCheckedArtista: Bool = false
//
//    private let firebaseAuth = FirebaseAuthActions()
//    private let firestoreActions = FirestoreActions()
//    
//    func signUp() {
//        guard !name.isEmpty, !cpfCnpj.isEmpty, !email.isEmpty, !password.isEmpty, !confirmPassword.isEmpty else {
//            errorMessage = "Por favor, preencha todos os campos."
//            return
//        }
//        
//        guard password == confirmPassword else {
//            errorMessage = "As senhas não coincidem."
//            return
//        }
//        
//        guard isCheckedArtista == true && isCheckedEmpresa == false || isCheckedArtista == false && isCheckedEmpresa == true else {
//            errorMessage = "Você é uma Empresa ou um Artista?"
//            return
//        }
//        
//        let userType = isCheckedEmpresa ? 0 : 1
//        
//        firebaseAuth.signUp(withEmail: email, password: password) { result in
//            switch result {
//            case .success(let user):
//                self.saveUserData(uid: user.uid, userType: userType)
//            case .failure(let error):
//                self.errorMessage = error.localizedDescription
//            }
//        }
//    }
//    
//    func saveUserData(uid: String, userType: Int) {
//        firestoreActions.uploadDataUser(uid: uid, email: email, name: name, cpfCnpj: cpfCnpj, userType: userType) { result in
//            switch result {
//            case .success:
//                self.errorMessage = "Usuário cadastrado com sucesso!"
//                self.clearFields()
//            case .failure(let error):
//                self.errorMessage = "Erro ao salvar os dados do usuário: \(error.localizedDescription)"
//            }
//        }
//    }
//    
//    private func clearFields() {
//        email = ""
//        password = ""
//        confirmPassword = ""
//        name = ""
//        cpfCnpj = ""
//        isCheckedEmpresa = false
//        isCheckedArtista = false
//    }
//}
//
//class AdditionalInfoViewModel: ObservableObject {
//    @Published var cpfCnpj: String = ""
//    @Published var errorMessage: String = ""
//    @Published var isCheckedEmpresa: Bool = false
//    @Published var isCheckedArtista: Bool = false
//    
//    
//    func saveAdditionalUserData(user: UserProfile) {
//        guard !cpfCnpj.isEmpty else {
//            errorMessage = "Por favor, preencha todos os campos."
//            return
//        }
//        
//        guard isCheckedArtista == true && isCheckedEmpresa == false || isCheckedArtista == false && isCheckedEmpresa == true else {
//            errorMessage = "Você é uma Empresa ou um Artista?"
//            return
//        }
//        
//        let userType = isCheckedEmpresa ? 0 : 1
//        let db = Firestore.firestore()
//        let userData: [String: Any] = [
//            "cpfCnpj": cpfCnpj,
//            "userType": userType,
//            "createdAt": FieldValue.serverTimestamp()
//        ]
//
//        db.collection("users").document(user.uid).setData(userData) { error in
//            if let error = error {
//                self.errorMessage = "Erro ao salvar os dados do usuário: \(error.localizedDescription)"
//            } else {
//                self.errorMessage = "Dados do usuário salvos com sucesso!"
//            }
//        }
//    }
//}
//
//struct UserProfile: Codable {
//    let uid: String
//    let name: String
//    let email: String
//    let userType: Int?
//    
//    init(uid: String, data: [String: Any]) {
//        self.uid = uid
//        self.name = data["name"] as? String ?? ""
//        self.email = data["email"] as? String ?? ""
//        self.userType = data[FirestoreKeys.field_users_usertype.rawValue] as? Int ?? -1
//    }
//    
//    var clientTypeDescription: String {
//        switch self.userType {
//        case 0:
//            return "Empresa"
//        case 1:
//            return "Artista"
//        default:
//            return "Desconhecido"
//        }
//    }
//}
//
//
//enum CustomErrors: LocalizedError {
//    case emailNotVerified
//
//    var errorDescription: String? {
//        switch self {
//        case .emailNotVerified:
//            return "E-mail não verificado"
//        }
//    }
//}
//
//
//enum FirestoreKeys : String{
//    case table_users = "users"
//    case field_users_name = "name"
//    case field_users_email = "email"
//    case field_users_cpfcnpj = "cpfcnpj"
//    case field_users_usertype = "usertype"
//    
//    case table_usertypes = "usertypes"
//}
//
//
//struct FloatingPlaceholderTextField: View {
//    @Binding var text: String
//    var placeholder: String
//    @State private var isFocused: Bool = false
//    
//    var body: some View {
//        ZStack(alignment: .leading) {
//            // Background and border
//            RoundedRectangle(cornerRadius: 8)
//                .stroke(Color.color9, lineWidth: 0.4)
//                .background(Color.color2)
//                .cornerRadius(8)
//            
//            // Placeholder text
//
//                Text(placeholder)
//                .foregroundColor(isFocused || !text.isEmpty ? Color.color9 : .gray)
//                    .background(Color.clear)
//                    .padding(.horizontal, 15)
//                    .padding(.vertical, 8)
//                    .offset(y: (isFocused || !text.isEmpty) ? -45 : 0)
//                    .scaleEffect((isFocused || !text.isEmpty) ? 0.80 : 1.0, anchor: .leading)
//                    .animation(.easeInOut(duration: 0.2), value: isFocused || !text.isEmpty)
//            
//            
//            // Text field
//                TextField("", text: $text, onEditingChanged: { editing in
//                    withAnimation {
//                        isFocused = editing
//                    }
//                })
//                .padding()
//                .background(Color.clear) // Define o fundo do TextField como transparente
//                .disableAutocorrection(true)
//                .autocapitalization(.none)
//                .padding(.horizontal, 8) // Garante o preenchimento para corresponder ao placeholder
//            
//            // Secure field (hidden by default)
//            if !text.isEmpty && placeholder == "Senha" || !text.isEmpty && placeholder == "Confirme a Senha" {
//                SecureField("", text: $text)
//                    .padding()
//                    .background(Color.color2) // Define o fundo do SecureField como transparente
//                    .disableAutocorrection(true)
//                    .autocapitalization(.none)
//                    .padding(.horizontal, 8) // Garante o preenchimento para corresponder ao placeholder
//            }
//             
//        }
//        .padding(.horizontal)
//        .padding(.top, 15) // Add padding to avoid overlap
//    }
//}
//
//struct ContentView: View {
//
//    @StateObject private var viewModel = AuthenticationViewModel()
//    @StateObject private var additionalInfoViewModel = AdditionalInfoViewModel()
//    @State private var email: String = ""
//    @State private var errorMessage: String = ""
//    
//    var body: some View {
//        ZStack {
//            Group {
//                if viewModel.isSignedIn {
//                    if viewModel.showAdditionalInfoView {
//                        if let userProfile = viewModel.userProfile {
//                            AdditionalInfoView(user: userProfile)
//                                .environmentObject(additionalInfoViewModel)
//                        }
//                    } else {
//                        if let userProfile = viewModel.userProfile {
//                            HomeView(user: userProfile)
//                                .environmentObject(viewModel)
//                        } else {
//                            Text("Carregando dados do usuário...")
//                        }
//                    }
//                } else {
//                    loginView
//                }
//            }
//            .environmentObject(viewModel)
//            
//            if viewModel.isLoading {
//                LoadingView()
//            }
//        }
//    }
//    
//    private var loginView: some View {
//        BackgroundView {
//            VStack {
//                Spacer()
//                
//                Text("Coolvert")
//                    .foregroundColor(Color.color9)
//                    .font(.custom("Roboto-Thin", size: 48))
//                    .padding(.bottom, 20)
//                
//                Image("Logo1")
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 260, height: 260)
//                    .padding(.bottom, 10)
//                
//                // Email TextField
//                FloatingPlaceholderTextField(text: $viewModel.email, placeholder: "Email")
//                
//                // Password SecureField
//                FloatingPlaceholderTextField(text: $viewModel.password, placeholder: "Senha")
//                
//                // Login Button
//                Button(action: {
//                    viewModel.signIn()
//                }) {
//                    Text("Entrar")
//                        .frame(maxWidth: 260)
//                        .padding()
//                        .background(Color.color2)
//                        .foregroundColor(Color.color9)
//                        .cornerRadius(50)
//                }
//                .padding(.horizontal)
//                .padding(.top, 40)
//                
//                // Login with Google Button
//                Button(action: {
//                    viewModel.signInWithGoogle()
//                    viewModel.showAdditionalInfoView = true
//                }){
//                    HStack {
//                        Image("google")
//                            .resizable()
//                            .frame(width: 30, height: 30)
//                        Text("Entrar com Google")
//                    }
//                    .frame(maxWidth: 260)
//                    .padding(.vertical, 10)
//                    .padding(.horizontal)
//                    .background(Color.color2)
//                    .foregroundColor(Color.color9)
//                    .cornerRadius(50)
//                }
//                .padding(.horizontal)
//                
//                Text(viewModel.errorMessage)
//                    .foregroundColor(.red)
//                    .padding()
//                
//                Spacer()
//                
//                HStack {
//                    Button(action: {
//                        viewModel.sendPasswordReset()
//                    }) {
//                        Text("Esqueceu sua senha?")
//                            .foregroundColor(Color.color9)
//                    }
//                    
//
//                    
//                    Spacer()
//                    
//                    NavigationLink(destination: SignUpView()) {
//                        Text("Cadastre-se")
//                            .foregroundColor(Color.color9)
//                    }
//                }
//                .padding(.horizontal)
//                .padding(.bottom, 20)
//            }
//            .padding()
//        }
//    }
//}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
//
//
//@main
//struct CoolvertApp: App {
//    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
//    @StateObject private var viewModel = AuthenticationViewModel()
//
//    var body: some Scene {
//        WindowGroup {
//            NavigationView {
//                ContentView()
//                    .environmentObject(viewModel)
//            }
//        }
//    }
//}
//
//
//struct SignUpView: View {
//    @StateObject private var viewModel = SignUpViewModel()
//    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
//    
//    class AppDelegate: NSObject, UIApplicationDelegate {
//        func application(_ application: UIApplication,
//                         didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//            FirebaseApp.configure()
//            return true
//        }
//    }
//    
//    var body: some View {
//        BackgroundView {
//            VStack {
//                Text("Coolvert")
//                    .foregroundColor(Color.color9)
//                    .font(.custom("Roboto-Thin", size: 48))
//                    .padding(.top, 40)
//                
//                HStack {
//                    Button(action: {
//                        viewModel.isCheckedEmpresa.toggle()
//                        viewModel.isCheckedArtista = false
//                    }) {
//                        HStack {
//                            Image(viewModel.isCheckedEmpresa ? "martini2" : "martini")
//                                .resizable()
//                                .frame(width: 50, height: 50)
//                            Text("Empresa")
//                                .font(.custom("Roboto-Regular", size: 18))
//                                .foregroundColor(viewModel.isCheckedEmpresa ? .blue : .black)
//                        }
//                    }
//                    .padding(.trailing, 80)
//                    
//                    Button(action: {
//                        viewModel.isCheckedArtista.toggle()
//                        viewModel.isCheckedEmpresa = false
//                    }) {
//                        HStack {
//                            Image(viewModel.isCheckedArtista ? "microphone2" : "microphone")
//                                .resizable()
//                                .frame(width: 50, height: 50)
//                            Text("Artista")
//                                .font(.custom("Roboto-Regular", size: 18))
//                                .foregroundColor(viewModel.isCheckedArtista ? .blue : .black)
//                        }
//                    }
//                    .padding(.vertical)
//                }
//                .padding()
//                
//                
//                FloatingPlaceholderTextField(text: $viewModel.name, placeholder: "Nome")
//                
//                
//                FloatingPlaceholderTextField(text: $viewModel.cpfCnpj, placeholder: "CPF / CNPJ")
//                
//                
//                FloatingPlaceholderTextField(text: $viewModel.email, placeholder: "Email")
//                
//                
//                FloatingPlaceholderTextField(text: $viewModel.password, placeholder: "Senha")
//                
//                
//                FloatingPlaceholderTextField(text: $viewModel.confirmPassword, placeholder: "Confirme a Senha")
//                
//                HStack {
//                    Button(action: {
//                        viewModel.signUp()
//                    }) {
//                        Text("Cadastrar")
//                            .customButtonStyle()
//                    }
//                    .padding()
//                }
//                
//                Text(viewModel.errorMessage)
//                    .foregroundColor(.red)
//                    .padding()
//            }
//            .padding()
//        }
//    }
//}
//
//extension View {
//    
//    func customButtonStyle() -> some View {
//        self
//            .padding()
//            .frame(maxWidth: 260)
//            .foregroundColor(Color.color9)
//            .background(Color.color2)
//            .cornerRadius(50)
//    }
//}
//
//struct SignUpView_Previews: PreviewProvider {
//    static var previews: some View {
//        SignUpView()
//    }
//}
//
//
//struct AdditionalInfoView: View {
//    @EnvironmentObject var viewModel: AdditionalInfoViewModel
//    
//    let user: UserProfile
//    
//    var body: some View {
//        VStack {
//            HStack {
//                Button(action: {
//                    viewModel.isCheckedEmpresa.toggle()
//                    viewModel.isCheckedArtista = false
//                }) {
//                    HStack {
//                        Image(viewModel.isCheckedEmpresa ? "martini2" : "martini")
//                            .resizable()
//                            .frame(width: 50, height: 50)
//                        Text("Empresa")
//                            .font(.custom("Roboto-Regular", size: 18))
//                            .foregroundColor(viewModel.isCheckedEmpresa ? .blue : .black)
//                    }
//                }
//                .padding(.trailing, 80)
//                
//                Button(action: {
//                    viewModel.isCheckedArtista.toggle()
//                    viewModel.isCheckedEmpresa = false
//                }) {
//                    HStack {
//                        Image(viewModel.isCheckedArtista ? "microphone2" : "microphone")
//                            .resizable()
//                            .frame(width: 50, height: 50)
//                        Text("Artista")
//                            .font(.custom("Roboto-Regular", size: 18))
//                            .foregroundColor(viewModel.isCheckedArtista ? .blue : .black)
//                    }
//                }
//                .padding(.vertical)
//            }
//            .padding()
//            
//            VStack {
//                TextField("CPF/CNPJ", text: $viewModel.cpfCnpj)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                    .padding()
//                
//                Button(action: {
//                    viewModel.saveAdditionalUserData(user: user)
//                }) {
//                    Text("Salvar")
//                        .padding()
//                        .foregroundColor(.white)
//                        .background(Color.blue)
//                        .cornerRadius(8)
//                }
//                .padding()
//                
//                Text(viewModel.errorMessage)
//                    .foregroundColor(.red)
//                    .padding()
//            }
//            .padding()
//        }
//    }
//}
//
//
//struct HomeView: View {
//    @EnvironmentObject var viewModel: AuthenticationViewModel
//    
//    let user: UserProfile
//    let firebaseAuth = FirebaseAuthActions()
//
//    var body: some View {
//        VStack {
//            Text("Bem-vindo, \(user.name)!")
//                .font(.largeTitle)
//                .padding()
//
//            Text("Tipo de Cliente: \(user.clientTypeDescription)")
//                .font(.title2)
//                .padding()
//
//            Button(action: {
//                            viewModel.signOut()
//                        }) {
//                            Text("Logout")
//                                .frame(maxWidth: .infinity)
//                                .padding()
//                                .background(Color.red)
//                                .foregroundColor(.white)
//                                .cornerRadius(8)
//                        }
//                        .padding()
//        }
//    }
//}
//
//
//struct LoadingView: View {
//    @State private var isBlinking = false
//    
//    var body: some View {
//        ZStack {
//            Color.black.opacity(0.8)
//                .edgesIgnoringSafeArea(.all)
//            VStack {
//                Image("Logo1")
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 260, height: 260)
//                    .padding(.bottom, 1)
//                    .opacity(isBlinking ? 0.3 : 1.0) // Alterar a opacidade para efeito de piscar
//                    .onAppear {
//                        withAnimation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
//                            isBlinking.toggle()
//                        }
//                    }
//            }
//        }
//    }
//}
//
//
//struct PasswordResetPopup: UIViewControllerRepresentable {
//    @Binding var isPresented: Bool
//    @Binding var email: String
//    @Binding var errorMessage: String
//    var viewModel: AuthenticationViewModel
//    
//    
//    func makeUIViewController(context: Context) -> UIViewController {
//        let alert = UIAlertController(title: "Recuperar Senha", message: "Insira seu e-mail para recuperar sua senha", preferredStyle: .alert)
//        
//        alert.addTextField { textField in
//            textField.placeholder = "E-mail"
//            textField.text = self.email
//        }
//        
//        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel) { _ in
//            self.isPresented = false
//        })
//        
//        alert.addAction(UIAlertAction(title: "Enviar", style: .default) { _ in
//            if let textField = alert.textFields?.first, let email = textField.text {
//                self.email = email
//                self.viewModel.sendPasswordReset()
//            }
//        })
//
//        return alert
//    }
//    
//    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
//}
//
//
//class FirebaseAuthActions {
//    
//    private let firebaseAuth = Auth.auth()
//    
//    struct EmailNotVerifiedError: Error {
//        var localizedDescription: String {
//            return "O e-mail ainda não foi verificado."
//        }
//    }
//    
//    
//    func signIn(withEmail email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
//        firebaseAuth.signIn(withEmail: email, password: password) { authResult, error in
//            if authResult != nil {
//                
//                if let authUser = authResult?.user {
//                    
//                    if authUser.isEmailVerified {
//                        completion(.success(authUser))
//                    } else {
//                        self.singOut()
//                        completion(.failure(CustomErrors.emailNotVerified))
//                    }
//                }
//                
//            } else if let error = error {
//                completion(.failure(error))
//            }
//        }
//    }
//    
//    func signInWithGoogle(presentingViewController: UIViewController, completion: @escaping (Result<User, Error>) -> Void) {
//        guard let clientID = FirebaseApp.app()?.options.clientID else {
//            print("Erro: Client ID do Firebase não encontrado.")
//            let error = NSError(domain: "SignInError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Client ID do Firebase não encontrado."])
//            completion(.failure(error))
//            return
//        }
//        
//        _ = GIDConfiguration(clientID: clientID)
//        
//        GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) { user, error in
//            guard error == nil else {
//                print("Erro ao fazer login com o Google: \(error!.localizedDescription)")
//                completion(.failure(error!))
//                return
//            }
//            
//            guard let user = user as? GIDGoogleUser,
//                  let authentication = user.authentication,
//                  let idToken = authentication.idToken,
//                  let accessToken = authentication.accessToken else {
//                print("Erro: Não foi possível obter as credenciais de autenticação do usuário.")
//                let error = NSError(domain: "SignInError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Erro ao obter credenciais do usuário"])
//                completion(.failure(error))
//                return
//            }
//            
//            // Criando as credenciais para autenticar com o Firebase
//            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
//            
//            // Autenticação com Firebase
//            Auth.auth().signIn(with: credential) { authResult, error in
//                if let error = error {
//                    self.signOut()
//                    completion(.failure(error))
//                    return
//                }
//                
//                if let user = Auth.auth().currentUser {
//                    self.saveUserData(uid: user.uid,
//                                      name: user.displayName ?? "No Name",
//                                      email: user.email ?? "No Email",
//                                      userType: nil) { success in
//                        if success {
//                            completion(.success(user))
//                        } else {
//                            let error = NSError(domain: "UserDataSaveError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Erro ao salvar dados do usuário"])
//                            completion(.failure(error))
//                        }
//                    }
//                } else {
//                    let error = NSError(domain: "SignInError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Erro ao obter usuário atual do Firebase"])
//                    completion(.failure(error))
//                }
//            }
//        }
//    }
//
//
//    
//    func saveUserData(uid: String, name: String, email: String, userType: Int?, completion: @escaping (Bool) -> Void) {
//        let db = Firestore.firestore()
//        var userData: [String: Any] = [
//            "name": name,
//            "email": email,
//            "createdAt": FieldValue.serverTimestamp()
//        ]
//        
//        if let userType = userType {
//            userData["userType"] = userType
//        }
//        
//        db.collection("users").document(uid).setData(userData) { error in
//            if let error = error {
//                print("Erro ao salvar os dados do usuário: \(error.localizedDescription)")
//                completion(false)
//            } else {
//                print("Dados do usuário salvos com sucesso!")
//                completion(true)
//            }
//        }
//    }
//    
//    
//    func singOut () {
//        if firebaseAuth.currentUser != nil {
//            do {
//                try firebaseAuth.signOut()
//                
//            } catch _ {}
//        }
//    }
//    
//    func signUp(withEmail email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
//        firebaseAuth.createUser(withEmail: email, password: password) { authResult, error in
//            if let authResult = authResult {
//                authResult.user.sendEmailVerification()
//                completion(.success(authResult.user))
//            } else if let error = error {
//                completion(.failure(error))
//            }
//        }
//    }
//    
//    func getUser() -> User? {
//        return Auth.auth().currentUser
//    }
//}
//
//
//class FirestoreActions {
//        
//    let firestore = Firestore.firestore()
//    
//    func uploadDataUser( uid: String, email: String, name: String, cpfCnpj: String, userType : Int, completion: @escaping (Result<Void, Error>) -> Void) {
//        let dataUser: [String : Any] = [
//            FirestoreKeys.field_users_email.rawValue : email,
//            FirestoreKeys.field_users_name.rawValue : name,
//            FirestoreKeys.field_users_cpfcnpj.rawValue : cpfCnpj,
//            FirestoreKeys.field_users_usertype.rawValue : userType
//        ]
//        
//        firestore.collection(FirestoreKeys.table_users.rawValue)
//            .document(uid)
//            .setData(dataUser) { error in
//                if let error = error {
//                    completion(.failure(error))
//                } else {
//                    completion(.success(()))
//                }
//            }
//    }
//    
//    func updateUserField(uid: String, value: Any, field: String) {
//        firestore
//            .collection(FirestoreKeys.table_users.rawValue)
//            .document(uid)
//            .setValue(value, forKey: field)
//    }
//    
//}
//
//
//class AppDelegate: UIResponder, UIApplicationDelegate {
//    
//    var window: UIWindow?
//    
//    func application(_ application: UIApplication,
//                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        
//        FirebaseApp.configure()
//        // Configuração do Google Sign-In
//                GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
//                    if let error = error {
//                        print("Erro ao restaurar sessão anterior do Google Sign-In: \(error.localizedDescription)")
//                    }
//                }
//                
//                return true
//            }
//    
//    func application(
//      _ app: UIApplication,
//      open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]
//    ) -> Bool {
//      var handled: Bool
//
//      handled = GIDSignIn.sharedInstance.handle(url)
//      if handled {
//        return true
//      }
//
//      // Handle other custom URL types.
//
//      // If not handled by this app, return false.
//      return false
//    }
//}
//
//
//Agora você tem todo o codigo do meu App. Me ajude a resolver o erro "Trailing closure passed to parameter of type 'String?' that does not accept a closure"

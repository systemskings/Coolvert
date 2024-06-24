import SwiftUI
import GoogleSignIn
import GoogleSignInSwift

struct ContentView: View {
    @StateObject private var viewModel = AuthenticationViewModel()
    @StateObject private var additionalInfoViewModel = AdditionalInfoViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                switch viewModel.viewState {
                case .loading:
                    LoadingView()
                case .signedIn(let userProfile):
                    HomeView(user: userProfile)
                        .environmentObject(viewModel)
                case .showAdditionalInfo(let userProfile):
                    AdditionalInfoView(user: userProfile)
                        .environmentObject(additionalInfoViewModel)
                        .environmentObject(viewModel)
                case .error(let message):
                    ErrorView(errorMessage: message) {
                        viewModel.viewState = .login
                    }
                case .login:
                    loginView
                }
            }
            .navigationBarHidden(true)
        }
        .onAppear {
            viewModel.checkUserStatus()
        }
    }
    
    
    private var loginView: some View {
        BackgroundView {
            VStack {
                Spacer()
                
                Text("Coolvert")
                    .foregroundColor(Color.color9)
                    .font(.custom("Roboto-Thin", size: 48))
                    .padding(.bottom, 20)
                
                Image("Logo1")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 260, height: 260)
                    .padding(.bottom, 10)
                
                FloatingPlaceholderTextField(text: $viewModel.email, placeholder: "Email")
                FloatingPlaceholderTextField(text: $viewModel.password, placeholder: "Senha")
                
                Button(action: viewModel.signIn) {
                    Text("Entrar")
                        .frame(maxWidth: 260)
                        .padding()
                        .background(Color.color2)
                        .foregroundColor(Color.color9)
                        .cornerRadius(50)
                }
                .padding(.horizontal)
                .padding(.top, 30)
                
                Button(action: viewModel.signInWithGoogle) {
                    HStack {
                        Image("google")
                            .resizable()
                            .frame(width: 30, height: 30)
                        Text("Entrar com Google")
                    }
                    .frame(maxWidth: 260)
                    .padding(.vertical, 10)
                    .padding(.horizontal)
                    .background(Color.color2)
                    .foregroundColor(Color.color9)
                    .cornerRadius(50)
                }
                .padding(.horizontal)
                
                Text(viewModel.errorMessage)
                    .foregroundColor(.red)
                    .padding()
                
                Spacer()
                
                HStack {
                    Button(action: viewModel.sendPasswordReset) {
                        Text("Esqueceu sua senha?")
                            .foregroundColor(Color.color9)
                    }
                    
                    Spacer()
                    
                    NavigationLink(destination: SignUpView()) {
                        Text("Cadastre-se")
                            .foregroundColor(Color.color9)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

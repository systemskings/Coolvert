import SwiftUI

struct HomeView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    
    let user: UserProfile

    var body: some View {
        VStack {
            Text("Bem-vindo, \(user.name)!")
                .font(.largeTitle)
                .padding()

            Text("Tipo de Cliente: \(user.clientTypeDescription)")
                .font(.title2)
                .padding()

            Button(action: {
                viewModel.signOut()
            }) {
                Text("Logout")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()
        }
    }
}

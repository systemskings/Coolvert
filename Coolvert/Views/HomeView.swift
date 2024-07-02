import SwiftUI

struct HomeView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @StateObject private var firestoreService = FirestoreService()

    var user: UserProfile

    var body: some View {
        NavigationView {
            VStack {
                Text("Bem-vindo, \(user.name)!")
                    .font(.largeTitle)
                    .padding()

                Text("Tipo de Cliente: \(user.clientTypeDescription)")
                    .font(.title2)
                    .padding()

                List(firestoreService.users) { user in
                    UserCell(user: user)
                }
                .listStyle(PlainListStyle())

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
            .onAppear {
                firestoreService.fetchUsers(excluding: user.uid)
            }
            .navigationBarHidden(true)
        }
    }
}

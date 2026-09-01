import SwiftUI

struct LoginView: View {
    @EnvironmentObject var rootVM: RootViewModel
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("VICE CITY COMPANION")
                    .font(.largeTitle.bold())
                    .foregroundStyle(Constants.Colors.primary)
                    .padding(.bottom, 40)
                
                TextField("Email", text: $email)
                    .textFieldStyle(.roundedBorder)
                    .autocapitalization(.none)
                
                SecureField("Password", text: $password)
                    .textFieldStyle(.roundedBorder)
                
                Button("Sign In") {
                    // Mock login
                    let mockUser = User(id: "1", username: "tester", email: email, avatar: nil, joinDate: Date(), bio: nil, postCount: 0, trophyCount: 0, contributedGuides: 0)
                    rootVM.login(user: mockUser, token: "mock_token")
                }
                .buttonStyle(.borderedProminent)
                .tint(Constants.Colors.primary)
                .frame(maxWidth: .infinity)
                .padding(.top)
                
                NavigationLink("Don't have an account? Register", destination: RegisterView())
                    .foregroundStyle(Constants.Colors.secondary)
            }
            .padding()
            .preferredColorScheme(.dark)
        }
    }
}

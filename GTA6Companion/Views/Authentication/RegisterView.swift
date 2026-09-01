import SwiftUI

struct RegisterView: View {
    @EnvironmentObject var rootVM: RootViewModel
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Create Account")
                .font(.largeTitle.bold())
                .foregroundStyle(Constants.Colors.primary)
            
            TextField("Username", text: $username)
                .textFieldStyle(.roundedBorder)
                .autocapitalization(.none)
            
            TextField("Email", text: $email)
                .textFieldStyle(.roundedBorder)
                .autocapitalization(.none)
            
            SecureField("Password", text: $password)
                .textFieldStyle(.roundedBorder)
            
            Button("Register") {
                let mockUser = User(id: "2", username: username, email: email, avatar: nil, joinDate: Date(), bio: nil, postCount: 0, trophyCount: 0, contributedGuides: 0)
                rootVM.login(user: mockUser, token: "mock_token_register")
            }
            .buttonStyle(.borderedProminent)
            .tint(Constants.Colors.primary)
            .frame(maxWidth: .infinity)
        }
        .padding()
        .preferredColorScheme(.dark)
    }
}

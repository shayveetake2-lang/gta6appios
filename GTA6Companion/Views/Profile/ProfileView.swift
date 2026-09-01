import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var rootVM: RootViewModel
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                if let user = rootVM.currentUser {
                    Circle()
                        .fill(Constants.Colors.primary)
                        .frame(width: 100, height: 100)
                        .overlay(
                            Text(String(user.username.prefix(1)).capitalized)
                                .font(.largeTitle.bold())
                                .foregroundStyle(.white)
                        )
                    
                    Text(user.username)
                        .font(.title2.bold())
                    
                    Text(user.email)
                        .foregroundStyle(.secondary)
                    
                    HStack(spacing: 20) {
                        StatCard(title: "Posts", value: "\(user.postCount)")
                        StatCard(title: "Trophies", value: "\(user.trophyCount)")
                        StatCard(title: "Guides", value: "\(user.contributedGuides)")
                    }
                    .padding(.vertical)
                    
                    Button("Sign Out", role: .destructive) {
                        rootVM.logout()
                    }
                    .buttonStyle(.bordered)
                    .padding(.top, 40)
                    
                } else {
                    Text("No user data")
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Profile")
            .preferredColorScheme(.dark)
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack {
            Text(value).font(.title.bold())
            Text(title).font(.caption).foregroundStyle(.secondary)
        }
        .frame(minWidth: 80)
        .padding()
        .background(Constants.Colors.cardBackground)
        .cornerRadius(12)
    }
}

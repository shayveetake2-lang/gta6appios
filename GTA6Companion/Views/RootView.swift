import SwiftUI

struct RootView: View {
    @EnvironmentObject var rootVM: RootViewModel
    
    var body: some View {
        if rootVM.isAuthenticated {
            MainTabView()
        } else {
            LoginView()
        }
    }
}

struct MainTabView: View {
    var body: some View {
        TabView {
            FeedView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            
            WalkthroughListView()
                .tabItem {
                    Label("Guides", systemImage: "map")
                }
            
            TrophyListView()
                .tabItem {
                    Label("Trophies", systemImage: "trophy")
                }
            
            ForumListView()
                .tabItem {
                    Label("Forum", systemImage: "bubble.left.and.bubble.right")
                }
            
            ProfileView()
                .tabItem {
                    Label("Account", systemImage: "person.crop.circle")
                }
        }
        .tint(Constants.Colors.primary)
    }
}

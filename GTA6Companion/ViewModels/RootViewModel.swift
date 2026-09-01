import Foundation
import Combine

@MainActor
class RootViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentUser: User?
    
    init() {
        checkAuthStatus()
    }
    
    func checkAuthStatus() {
        if StorageManager.shared.getToken() != nil {
            self.isAuthenticated = true
            // Ideally fetch user profile here
        } else {
            self.isAuthenticated = false
        }
    }
    
    func login(user: User, token: String) {
        StorageManager.shared.saveToken(token)
        self.currentUser = user
        self.isAuthenticated = true
    }
    
    func logout() {
        StorageManager.shared.deleteToken()
        self.currentUser = nil
        self.isAuthenticated = false
    }
}

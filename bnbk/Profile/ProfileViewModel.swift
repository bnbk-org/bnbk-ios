//
//  ProfileViewModel.swift
//  bnbk
//
//  Created by Heryan Djaruma on 20/09/24.
//

import Foundation
import FirebaseAuth
import OSLog

extension ProfileView {
    
    @Observable
    class ViewModel {
        
        private var log = Logger()
        
        var user: User?
        var name: String?
        
        init(displayName: String? = nil) {
            if let displayName = displayName {
                self.name = displayName
            } else {
                Auth.auth().addStateDidChangeListener { [weak self] _, firebaseUser in
                    guard let self = self else { return }
                    guard let firebaseUser = firebaseUser else {
                        self.log.error("No Firebase user found.")
                        return
                    }
                    
                    self.name = firebaseUser.displayName
                    self.user = User(
                        id: firebaseUser.uid,
                        username: firebaseUser.displayName,
                        email: firebaseUser.email,
                        phone: nil,
                        bio: nil
                    )
                    Task {
                        await self.fetchUserDetailsFromBackend(userId: firebaseUser.uid)
                    }
                }
            }
        }
        
        /// Fetch user details from your backend
        func fetchUserDetailsFromBackend(userId: String) async {
            do {
                guard let url = URL(string: "https://web.bnbk.org/api/user/\(userId)") else {
                    self.log.error("Invalid URL.")
                    return
                }
                
                let (data, _) = try await URLSession.shared.data(from: url)
                let fetchedUser = try JSONDecoder().decode(User.self, from: data)
                
                // Update user with backend data
                DispatchQueue.main.async {
                    self.user?.username = fetchedUser.username
                    self.user?.phone = fetchedUser.phone
                    self.user?.bio = fetchedUser.bio
                }
                
            } catch {
                self.log.error("Failed to fetch user details: \(error.localizedDescription)")
            }
        }
        
        /// Sign out the user
        func signOut() {
            do {
                try Auth.auth().signOut()
                self.log.info("User signed out")
                self.user = nil // Reset the user data on sign out
                self.name = nil
            } catch {
                self.log.error("Error signing out: \(error.localizedDescription)")
            }
        }
    }
}

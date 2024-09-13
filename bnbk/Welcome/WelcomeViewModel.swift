//
//  WelcomeViewModel.swift
//  bnbk
//
//  Created by Heryan Djaruma on 13/09/24.
//

import Foundation
import FirebaseAuth

extension WelcomeView {
    class WelcomeViewModel: ObservableObject {
        @Published var user: User?
        
        private var authListener: AuthStateDidChangeListenerHandle?
        
        
        init() {
            self.authListener = Auth.auth().addStateDidChangeListener { _, user in
                self.user = user
            }
        }
        
        deinit {
            if let handle = authListener {
                Auth.auth().removeStateDidChangeListener(handle)
            }
        }
    }
    
}

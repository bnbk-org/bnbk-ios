//
//  ProfileViewModel.swift
//  bnbk
//
//  Created by Heryan Djaruma on 20/09/24.
//

import Foundation
import FirebaseAuth

extension ProfileView {
    
    @Observable
    class ViewModel {
        
        var displayName: String?
        
        init(displayName: String? = nil) {
            if let displayName = displayName {
                self.displayName = displayName
            } else {
                Auth.auth().addStateDidChangeListener { [weak self] _, user in
                    self?.displayName = user?.displayName
                }
            }
        }
    }
}

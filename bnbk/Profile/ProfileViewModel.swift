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
        
        var user: User? = nil
        
        init() {
            Auth.auth().addStateDidChangeListener { [weak self] _, user in
                self?.user = user
            }
        }
        
    }
}

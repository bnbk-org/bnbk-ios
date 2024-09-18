//
//  ProfielView.swift
//  bnbk
//
//  Created by Heryan Djaruma on 24/05/24.
//

import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    var body: some View {
        VStack {
            Text("This is the main app view")
            Button("Sign Out") {
                signOut()
            }
        }
        .padding()
    }
    
    private func signOut() {
        do {
            try Auth.auth().signOut()
            print("User signed out")
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
}

#Preview {
    ProfileView()
}

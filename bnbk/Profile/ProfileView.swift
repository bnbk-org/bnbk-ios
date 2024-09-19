//
//  ProfielView.swift
//  bnbk
//
//  Created by Heryan Djaruma on 24/05/24.
//

import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    @State private var viewModel = ViewModel()
    
    var body: some View {
        VStack {
            Text("Profil")
                .font(Font.custom("Paytone One", size: 20))
            
            VStack {
                Circle()
                    .frame(width: 100, height: 100)
                    .foregroundStyle(Color.gray)
                
                if let user = viewModel.user, let displayName = user.displayName {
                    Text(displayName)
                }
            }
            Text("This is the main app view")
            Button("Sign Out") {
                signOut()
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("BG"))
        .navigationTitle("")
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

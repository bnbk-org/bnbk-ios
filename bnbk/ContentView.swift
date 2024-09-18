//
//  ContentView.swift
//  bnbk
//
//  Created by Heryan Djaruma on 17/05/24.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @State private var isUserLoggedIn: Bool = Auth.auth().currentUser != nil
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    
    var body: some View {
        
        NavigationStack {
            if !hasSeenOnboarding {
                OnboardingView()
            } else if !isUserLoggedIn {
                WelcomeView()
            } else {
                MainView()
            }
        }
        .onAppear {
            // Listen to auth state changes (realtime updates if user logs in/out)
            Auth.auth().addStateDidChangeListener { _, user in
                isUserLoggedIn = user != nil
            }
        }
    }
}

#Preview {
    ContentView()
}

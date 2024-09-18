//
//  OnboardingView.swift
//  bnbk
//
//  Created by Heryan Djaruma on 18/09/24.
//

import SwiftUI

struct OnboardingView: View {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false

    var body: some View {
        VStack {
            Text("Welcome to the Onboarding Screen")
            Button("Continue to Welcome Screen") {
                hasSeenOnboarding = true
            }
        }
        .padding()
    }
}

#Preview {
    OnboardingView()
}

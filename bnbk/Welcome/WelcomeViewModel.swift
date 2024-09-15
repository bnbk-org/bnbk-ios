//
//  WelcomeViewModel.swift
//  bnbk
//
//  Created by Heryan Djaruma on 13/09/24.
//

import Foundation
import FirebaseAuth
import GoogleSignIn
import FirebaseCore
import OSLog
import AuthenticationServices

extension WelcomeView {
    class WelcomeViewModel: ObservableObject {
        private var log = Logger()
        var currentNonce: String?
        
//        @Published var user: User?
    
//        private var authListener: AuthStateDidChangeListenerHandle?
//        
//        
//        init() {
//            self.authListener = Auth.auth().addStateDidChangeListener { _, user in
//                self.user = user
//            }
//        }
//        
//        deinit {
//            if let handle = authListener {
//                Auth.auth().removeStateDidChangeListener(handle)
//            }
//        }
        
        func handleGoogleSignIn() {
            guard let clientID = FirebaseApp.app()?.options.clientID else {
                self.log.error("No client ID found in Firebase configuration")
                return
            }

            let config = GIDConfiguration(clientID: clientID)
            GIDSignIn.sharedInstance.configuration = config

            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
                self.log.error("No window scene found")
                return
            }

            guard let rootViewController = windowScene.windows.first?.rootViewController else {
                print("No root view controller found")
                return
            }

            GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { signInResult, error in
                if let error = error {
                    self.log.error("Google Sign-In error: \(error.localizedDescription)")
                    return
                }

                guard let user = signInResult?.user,
                      let idToken = user.idToken?.tokenString else {
                    self.log.error("Google Sign-In: No user or ID token found")
                    return
                }

                let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                               accessToken: user.accessToken.tokenString)

                Auth.auth().signIn(with: credential) { authResult, error in
                    if let error = error {
                        self.log.error("Firebase sign-in with Google credential error: \(error.localizedDescription)")
                        return
                    }
                    self.log.info("User signed in with Google")
                }
            }
        }
        
        func signInToFirebase(_ authResults: ASAuthorization) {
            guard let appleIDCredential = authResults.credential as? ASAuthorizationAppleIDCredential else {
                print("Invalid state: Expected an Apple ID credential.")
                return
            }

            guard let nonce = currentNonce else {
                print("Invalid state: No nonce value.")
                return
            }

            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token.")
                return
            }

            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }

            let credential = OAuthProvider.credential(
                withProviderID: "apple.com",
                idToken: idTokenString,
                rawNonce: nonce
            )

            Auth.auth().signIn(with: credential) { (authResult, error) in
                if let error = error {
                    print("Error authenticating: \(error.localizedDescription)")
                    return
                }
                print("User signed in with Apple")
            }
        }
    }
    
}

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
        @Published var isUserLoggedIn: Bool = false
        private var authListener: AuthStateDidChangeListenerHandle?
        
        
        private var log = Logger()
        var currentNonce: String?
        
//        @Published var user: User?
    
//        
//        
        init() {
                listenToAuthState()
            }

            // Listen for authentication state changes
            private func listenToAuthState() {
                authListener = Auth.auth().addStateDidChangeListener { _, user in
                    self.isUserLoggedIn = user != nil
                }
            }
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

            // The getRootViewController() function is necessary to present the 
            // Google Sign-In view controller from SwiftUI, as the sign-in flow
            // requires a UIKit view controller for presentation.
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
                self.log.error("No window scene found")
                return
            }

            guard let rootViewController = windowScene.windows.first?.rootViewController else {
                print("No root view controller found")
                return
            }
            ///

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
        
        func appleSignIn(_ authResults: ASAuthorization) {
            guard let appleIDCredential = authResults.credential as? ASAuthorizationAppleIDCredential else {
                self.log.error("Invalid state: Expected an Apple ID credential.")
                return
            }

            guard let nonce = currentNonce else {
                self.log.info("Invalid state: No nonce value.")
                return
            }

            guard let appleIDToken = appleIDCredential.identityToken else {
                self.log.error("Unable to fetch identity token.")
                return
            }

            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                self.log.info("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }

            let credential = OAuthProvider.credential(
                withProviderID: "apple.com",
                idToken: idTokenString,
                rawNonce: nonce
            )

            Auth.auth().signIn(with: credential) { (authResult: AuthDataResult?, error: Error?) in
                if let error = error {
                    self.log.error("Error authenticating: \(error.localizedDescription)")
                    return
                }

                self.log.info("User signed in with Apple")

                guard let authResult = authResult else {
                    self.log.error("No auth result.")
                    return
                }

                let uid = authResult.user.uid
                let email = authResult.user.email ?? "No email"
                self.log.info("Firebase UID: \(uid), Email: \(email)")

                // Register UID and Email
                self.sendPostRequest(id: uid, email: email)
            }

        }
        
        func sendPostRequest(id: String, email: String) {
            let url = URL(string: "https://web.bnbk.org/api/user")!
            
            let payload = RegisterPayload(id: id, email: email)
            
            guard let jsonData = try? JSONEncoder().encode(payload) else {
                self.log.error("Error encoding payload")
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    self.log.error("Error sending request: \(error.localizedDescription)")
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    self.log.info("Status code: \(httpResponse.statusCode)")
                }
                
                if let data = data {
                    let responseString = String(data: data, encoding: .utf8)
                    self.log.info("Response: \(responseString ?? "No response")")
                }
            }
            
            task.resume()
        }
        
        
    }
    
    struct RegisterPayload: Codable {
        let id: String
        let email: String
    }
}

//
//  WelcomeView.swift
//  bnbk
//
//  Created by Heryan Djaruma on 10/09/24.
//

import SwiftUI
import AuthenticationServices
import FirebaseAuth
import GoogleSignIn
import FirebaseCore

struct WelcomeView: View {
    
    @State private var currentNonce: String?
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Image("BG Blue")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            GeometryReader { geometry in 
            
                Rectangle()
                    .foregroundStyle(
                        LinearGradient(gradient: Gradient(colors: [Color.white.opacity(0), Color.white]), startPoint: .top, endPoint: .bottom)
                    )
                    .frame(maxWidth: .infinity, maxHeight: geometry.size.height/2)
                    .position(x: geometry.size.width / 2, y: geometry.size.height * 3 / 4)
            }
            
            GeometryReader { geometry in
                VStack(alignment: .center) {
                    
                    Text("Haleluya ☝️")
                        .font(Font.custom("Paytone One", size: 32))
                        .bold()
                        .font(.title)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundStyle(Color.white)
                    
                    Text("Selamat datang di aplikasi BNBK!")
                        .foregroundStyle(Color.white)
                        .font(.title3)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Spacer()
                        .frame(height: 20)
                    
                    Text("Cari lagu atau koor dalam buku nyanyian, aransemen, audio, dan video prajurit Bala Keselamatan dari seluruh dunia 🌏")
                        .foregroundStyle(Color.white)
                        .font(.subheadline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Spacer()
                        .frame(height: geometry.size.height*1/8)
                    
                    Button(action: {
                        
                    }) {
                        Text("Lanjut ke Aplikasi")
                            .font(.title3)
                            .frame(maxWidth: .infinity, maxHeight: 20)
                            .foregroundColor(Color("PrimaryColor"))
                            .padding()
                    }
                    .background {
                        RoundedRectangle(cornerRadius: .infinity)
                            .foregroundColor(Color.white)
                    }
                    .shadow(color: Color.black.opacity(0.1) , radius: 10)
                   
                    HStack {
                        VStack { Divider()
                                .background(Color.white)
                                .padding() }
                        Text("Atau")
                            .font(.subheadline)
                            .foregroundStyle(Color.white)
                        VStack { Divider()
                                .background(Color.white)
                                .padding() }
                    }
                    
                    Button(action: {
                        handleGoogleSignIn()
                    }) {
                        HStack(alignment: .center) {
                            Spacer()
                            Image("Google Icon")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30)
                                .padding(0)
                            Text("Masuk dengan Google")
                                .font(.title3)
                                .foregroundColor(Color("PrimaryColor"))
                                .padding(0)
                            Spacer()
                        }
                        .frame(height: 20)
                        .padding()
                    }
                    .background {
                        RoundedRectangle(cornerRadius: .infinity)
                            .foregroundColor(Color.white)
                    }
                    .shadow(color: Color.black.opacity(0.1) , radius: 10)
                    
                    
                    SignInWithAppleButton(.signIn) { request in
                        let nonce = randomNonceString()
                        currentNonce = nonce
                        request.requestedScopes = [.fullName, .email]
                        request.nonce = sha256(nonce)
                    } onCompletion: { result in
                        handleAuthorization(result: result)
                    }
                    .signInWithAppleButtonStyle(.black)
                    .frame(height: 50)
                    .cornerRadius(.infinity)
                    .shadow(color: Color.black.opacity(0.1) , radius: 10)
                }
                .padding()
                .position(x: geometry.size.width / 2, y: geometry.size.height/2)
            }
        }
        .ignoresSafeArea()
    }
    
    private func handleAuthorization(result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let authResults):
            signInToFirebase(authResults)
        case .failure(let error):
            print("Authorization failed: \(error.localizedDescription)")
        }
    }
    
    private func signInToFirebase(_ authResults: ASAuthorization) {
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
            // User is signed in to Firebase with Apple.
            // You can navigate to the next view or update the UI.
        }
    }
    
    private func handleGoogleSignIn() {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            print("No client ID found in Firebase configuration")
            return
        }

        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            print("No window scene found")
            return
        }

        guard let rootViewController = windowScene.windows.first?.rootViewController else {
            print("No root view controller found")
            return
        }

        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { signInResult, error in
            if let error = error {
                print("Google Sign-In error: \(error.localizedDescription)")
                return
            }

            guard let user = signInResult?.user,
                  let idToken = user.idToken?.tokenString else {
                print("Google Sign-In: No user or ID token found")
                return
            }

            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)

            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print("Firebase sign-in with Google credential error: \(error.localizedDescription)")
                    return
                }
                print("User signed in with Google")
                // Navigate to the next view or update the UI
            }
        }
    }

}

#Preview {
    WelcomeView()
}

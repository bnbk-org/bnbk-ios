//
//  WelcomeView.swift
//  bnbk
//
//  Created by Heryan Djaruma on 10/09/24.
//

import SwiftUI
import AuthenticationServices


struct WelcomeView: View {
    @StateObject private var viewModel = WelcomeViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                GeometryReader { geometry in
                    VStack {
                        Image("SA Landing")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 15, height: 15)))
                        
                        VStack(alignment: .center) {
                            Text("Haleluya ☝️")
                                .font(Font.custom("Paytone One", size: 32))
                                .bold()
                                .font(.largeTitle)
                                .foregroundStyle(Color("Primary"))
                            
                            Text("Selamat datang di aplikasi BNBK!")
                                .font(Font.custom("Helvetica Neue", size: 20))
                                .foregroundStyle(.black)
                                .font(.title3)
                                .padding(.top, 5)
                            
                            Text("Cari lagu atau koor dalam buku nyanyian, aransemen, audio, dan video prajurit Bala Keselamatan dari seluruh dunia 🌏")
                                .foregroundStyle(.black)
                                .font(Font.custom("Helvetica Neue", size: 16))
                                .multilineTextAlignment(.center)
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(.top, 20)
                        }
                        .padding()
                        
                        Spacer()
                    }
                    
                    VStack(spacing: 20) {
                        Button(action: {
                            viewModel.handleGoogleSignIn()
                        }) {
                            HStack(alignment: .center) {
                                Spacer()
                                Image("Google Icon")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 20)
                                Text("Masuk dengan Google")
                                    .font(.body)
                                    .foregroundColor(.black)
                                Spacer()
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: .infinity)
                                    .foregroundColor(Color.white)
                            )
                            .shadow(color: Color.black.opacity(0.1), radius: 10)
                        }
                        .frame(height: 50)
                        
                        SignInWithAppleButton(.signIn) { request in
                            request.requestedScopes = [.fullName, .email]
                            let nonce = randomNonceString()
                            viewModel.currentNonce = nonce
                            request.nonce = sha256(nonce)
                        } onCompletion: { result in
                            handleAuthorization(result: result)
                        }
                        .signInWithAppleButtonStyle(.black)
                        .frame(height: 50)
                        .cornerRadius(.infinity)
                        .shadow(color: Color.black.opacity(0.1), radius: 10)
                        
                        HStack {
                            Spacer()
                            HStack {
                                Text("Lewati")
                                Image(systemName: "chevron.right")
                            }
                            .foregroundStyle(.black)
                        }
                        .padding()
                        .onTapGesture {
                            viewModel.anonymousSignIn()
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                }
            }
            .background(Color("BG"))
            .edgesIgnoringSafeArea(.top)
        }
         
     }
    
    private func handleAuthorization(result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let authResults):
            viewModel.appleSignIn(authResults)
        case .failure(let error):
            print("Authorization failed: \(error.localizedDescription)")
        }
    }
}

#Preview {
    WelcomeView()
}

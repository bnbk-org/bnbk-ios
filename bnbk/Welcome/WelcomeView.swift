//
//  WelcomeView.swift
//  bnbk
//
//  Created by Heryan Djaruma on 10/09/24.
//

import SwiftUI
import AuthenticationServices

struct WelcomeView: View {
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
                        
                    } onCompletion: { result in
                        
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
}

#Preview {
    WelcomeView()
}

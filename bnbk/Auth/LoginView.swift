//
//  LoginView.swift
//  bnbk
//
//  Created by Heryan Djaruma on 09/09/24.
//

import SwiftUI

struct LoginView: View {
    
    @State var email = ""
    @State var password = ""
    
    var body: some View {
        VStack(alignment: .center) {
            Rectangle()
                .frame(maxWidth: .infinity, maxHeight: 250)
                .foregroundStyle(Color("PrimaryColor"))
            
            Text("Masuk")
                .font(.title)
                .padding()
            
            VStack(alignment: .leading) {
                Text("Email")
                    .font(.headline)
                
                TextField("Email", text: $email)
                    .padding(.vertical)
                    .padding(.horizontal, 24)
                    .background(Color(UIColor.systemGray6))
                    .clipShape(Capsule(style: .continuous))
                
                Spacer()
                    .frame(height: 30)
        
                Text("Kata Sandi")
                    .font(.headline)
                
                SecureField("Kata Sandi", text: $password)
                    .padding(.vertical)
                    .padding(.horizontal, 24)
                    .background(Color(UIColor.systemGray6))
                    .clipShape(Capsule(style: .continuous))
                
                HStack {
                    Spacer()
                    Text("Lupa kata sandi")
                        .foregroundStyle(Color.blue)
                        .font(.callout)
                        .padding(.horizontal)
                }
            }
            .padding()
            
            Spacer()
                .frame(height: 30)
            
            HStack {
                Text("Belum memiliki akun?")
                    .font(.callout)
                Text("Daftar")
                    .foregroundStyle(Color.blue)
                    .font(.callout)
            }
            
            Button(action: {
                
            }) {
                Text("Masuk")
                    .bold()
                    .frame(maxWidth: .infinity)
                    .foregroundColor(Color.white)
                    .padding()
            }
            .background {
                RoundedRectangle(cornerRadius: .infinity)
                    .foregroundColor(Color("PrimaryColor"))
            }
            .padding()
            
            Spacer()
            
            Button("Heyto") {
                
            }
                .buttonStyle(.borderedProminent)
        }
        .ignoresSafeArea(.keyboard)
        .ignoresSafeArea(edges: .top)
    }
}

#Preview {
    LoginView()
}

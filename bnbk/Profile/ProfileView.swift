//
//  ProfielView.swift
//  bnbk
//
//  Created by Heryan Djaruma on 24/05/24.
//

import SwiftUI

struct ProfileView: View {
    @State private var viewModel: ViewModel
    
    init(viewModel: ViewModel = ViewModel()) {
        _viewModel = State(initialValue: viewModel)
    }
    
    var body: some View {
        VStack {
            Text("Profil")
                .font(Font.custom("Paytone One", size: 20))
                .padding()
            
            VStack {
                Circle()
                    .frame(width: 100, height: 100)
                    .foregroundStyle(Color.gray)
                
                if let displayName = viewModel.name {
                    Text(displayName)
                        .font(Font.custom("Helvetica Neue", size: 20))
                        .padding()
                }
                
                if let email = viewModel.user?.email {
                    Text(email)
                        .font(Font.custom("Helvetica Neue", size: 16))
                }
                
                Button(action: {
                    
                }) {
                    Text("Edit Profile")
                        .font(Font.custom("Helvetica Neue", size: 15))
                        .bold()
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 15)
                .foregroundStyle(Color.white)
                .background {
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color("Secondary"))
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                .fill(Color.white))
            Button(action: {
                
            }) {
                
            }
            
            VStack {
                Button(action: {
                    viewModel.signOut()
                }) {
                    HStack {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                        Text("Logout")
                            .font(Font.custom("Helvetica Neue", size: 15))
                            .bold()
                    }

                }
                .padding(.vertical, 10)
                .padding(.horizontal, 15)
                .foregroundStyle(Color("Primary"))
                .background {
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.white)
                }
            }
            .padding()
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("BG"))
        .navigationTitle("Profil")
    }
    

}

#Preview {
    let sampleViewModel = ProfileView.ViewModel(displayName: "Preview User")
    return ProfileView(viewModel: sampleViewModel)
}


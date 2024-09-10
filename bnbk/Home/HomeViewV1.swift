//
//  HomeViewV1.swift
//  bnbk
//
//  Created by Heryan Djaruma on 06/09/24.
//

import SwiftUI

struct HomeViewV1: View {
    
    let columns = [
        GridItem(.flexible(), spacing: Constant.GridSpacing),
        GridItem(.flexible(), spacing: Constant.GridSpacing)
    ]
    
    let recentColumns = [
        GridItem(.flexible(), spacing: Constant.GridSpacing)
    ]
    
    var body: some View {
        VStack(alignment: .leading) {
            
            ScrollView {
                // song of the day
                VStack(alignment: .leading) {
                    Text("Sorotan Hari Ini")
                        .font(.title)
                    VStack {
                        ZStack {
                            Image("congregational")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .clipShape(RoundedRectangle(cornerSize: CGSize(width: Constant.SmallRadius, height: Constant.SmallRadius)))
                        }
                    }
                }.padding()
                
                // shortcut
                VStack(alignment: .leading) {
                    Text("Konten")
                        .font(.title)
                    LazyVGrid(columns: columns, spacing: Constant.GridSpacing) {
                        
                        HStack {
                            Image(systemName: "book.pages")
                            Text("Nyanyian")
                                .font(.callout)
                        }
                        .padding()
                        .frame(minWidth: 20, idealWidth: 100, maxWidth: .infinity, minHeight: 20, idealHeight: 60, maxHeight: .infinity, alignment: .center)
                        .background(Color.white)
                        .foregroundColor(.black)
                        .cornerRadius(Constant.SmallRadius)
                        .shadow(color: Color.gray.opacity(0.3) ,radius: Constant.ShadowSmallRadius)
                        
                        HStack {
                            Image(systemName: "music.quarternote.3")
                            Text("Koor")
                                .font(.callout)
                        }
                        .padding()
                        .frame(minWidth: 20, idealWidth: 100, maxWidth: .infinity, minHeight: 20, idealHeight: 60, maxHeight: .infinity, alignment: .center)
                        .background(Color.white)
                        .foregroundColor(.black)
                        .cornerRadius(Constant.SmallRadius)
                        .shadow(color: Color.gray.opacity(0.3) ,radius: Constant.ShadowSmallRadius)
                        
                        HStack {
                            Image(systemName: "square.text.square.fill")
                            Text("Pengakuan Iman")
                                .font(.callout)
                        }
                        .padding()
                        .frame(minWidth: 20, idealWidth: 100, maxWidth: .infinity, minHeight: 20, idealHeight: 60, maxHeight: .infinity, alignment: .center)
                        .background(Color.white)
                        .foregroundColor(.black)
                        .cornerRadius(Constant.SmallRadius)
                        .shadow(color: Color.gray.opacity(0.3) ,radius: Constant.ShadowSmallRadius)
                    }
                }.padding()
                
                // placeholder
                VStack(alignment: .leading) {
                    
                    HStack {
                        Text("Baru saja")
                            .font(.title3)
                            .padding()
                        
                        Spacer()
                        
                        Text("Lihat semua")
                            .font(.callout)
                            .foregroundStyle(Color.blue)
                            .padding()
                        
                    }
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHGrid(rows: recentColumns, spacing: Constant.GridSpacing) {
                            Recent()
                            Recent()
                            Recent()
                        }
                    }
                    .safeAreaPadding(.horizontal, Constant.GridSpacing)
                    .scrollTargetBehavior(.paging)
                    
                }
                
                // news
                VStack(alignment: .leading) {
                    Text("Berita terbaru")
                        .font(.title3)
                        .padding()
                    
                }
            }
            
        }
        
        Spacer()
    }
}

struct Recent: View {
    var body: some View {
        VStack {
            Text("HELLO")
        }
        .frame(width: UIScreen.main.bounds.width * 0.8, height: 200)
        .background(Color.white)
        .cornerRadius(Constant.SmallRadius)
        .shadow(color: Color.gray.opacity(0.3) ,radius: Constant.ShadowSmallRadius)
        .padding(.vertical, CGFloat(10))
    }
}

#Preview {
    HomeViewV1()
}

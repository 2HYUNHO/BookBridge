//
//  HomeListItemView.swift
//  BookBridge
//
//  Created by 노주영 on 2/6/24.
//

import SwiftUI

struct HomeListItemView: View {
    @State var url = URL(string: "")
    
    var storageManager = HomeFirebaseManager.shared
    
    var author: String
    var bookmark: Bool
    var date: Date
    var id: String
    var imageLinks: [String]
    var isChange: Bool
    var locate: [Double]
    var title: String
    
    var body: some View {
        HStack {
            if imageLinks.isEmpty {
                Image("Character")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 75, height: 100)
                    .foregroundStyle(.black)
                    .padding()
            } else {
                if isChange {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .frame(width: 75, height: 100)
                            .foregroundStyle(.black)
                            .padding()
                    } placeholder: {
                        ProgressView()
                            .frame(width: 75, height: 100)
                            .padding()
                    }
                } else {
                    AsyncImage(url: URL(string: imageLinks[0])) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 75, height: 100)
                            .foregroundStyle(.black)
                            .padding()
                    } placeholder: {
                        ProgressView()
                            .frame(width: 75, height: 100)
                            .padding()
                    }
                }
            }
            
            
            VStack(alignment: .leading, spacing: 0){
                Divider().opacity(0)
                Text("\(title)")
                    .font(.system(size: 15))
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .padding(.top, 10)
                    .lineLimit(2)
                
                Text("\(author)")
                    .font(.system(size: 10))
                    .padding(.top, 5)
                    .foregroundStyle(Color(red: 75/255, green: 75/255, blue: 75/255))
                
                Spacer()
                
                Text("무슨동 | \(date)")
                    .font(.system(size: 10))
                    .padding(.bottom, 10)
                    .foregroundStyle(Color(red: 75/255, green: 75/255, blue: 75/255))
            }
            Spacer()
            VStack{
                Image(systemName: "bookmark")
                    .font(.system(size: 20))
                    .padding()
                    .foregroundColor(.black)
                
                Spacer()
            }
        }
        .frame(height: 120, alignment: .center)
        .background(
            RoundedRectangle(cornerRadius: 10, style: .circular)
                .foregroundColor(Color(red: 230/255, green: 230/255, blue: 230/255))
        )
        .onAppear {
            if !imageLinks.isEmpty && isChange {
                Task {
                    try await storageManager.downloadImage(noticeiId: id, imageId: imageLinks[0]) { url in
                        self.url = url
                    }
                }
            }
        }
    }
}
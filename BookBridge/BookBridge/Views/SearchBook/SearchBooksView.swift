//
//  SearchBooksView.swift
//  BookBridge
//
//  Created by 노주영 on 1/30/24.
//

import SwiftUI

struct SearchBooksView: View {
    @Environment(\.dismiss) private var dismiss
    
    @Binding var hopeBooks: [Item]
    
    @StateObject var viewModel = SearchBooksViewModel()
    
    var isWish : tapInfo
    
    var body: some View {
        
        VStack {
            
            ZStack{
                if isWish == .wish {
                    Text("희망도서 추가")
                }
                else if isWish == .search {
                    Text("희망도서 추가")
                }
                else {
                    Text("보유도서 추가")
                }
                
                HStack{
                    Button {
                        if !(isWish == .search) {
                            hopeBooks = []
                        }
                                                
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 16))
                            .foregroundStyle(.black)
                    }
                    
                    Spacer()
                    
                    Button {
                        hopeBooks = viewModel.selectBooks.items
                        dismiss()
                    } label: {
                        Text("확인")
                            .font(.system(size: 16))
                            .foregroundStyle(.black)
                    }
                    
                }
            }
            .padding(.top,8)
            .padding(.horizontal)
            
            
            SearchBarView(viewModel: viewModel)
                .frame(height: 36)
                .padding(.vertical, 20)
                .padding(.horizontal)
            
            if !viewModel.selectBooks.items.isEmpty {
                SelectBooksView(viewModel: viewModel)
            }
            
            SearchResultView(viewModel: viewModel)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationBarBackButtonHidden()
        .onAppear {
            viewModel.selectBooks.items = hopeBooks
        }
        .onTapGesture {
            hideKeyboard()
        }
    }
}

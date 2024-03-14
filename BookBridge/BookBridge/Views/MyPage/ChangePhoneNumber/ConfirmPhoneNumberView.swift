//
//  ConfirmPhoneNumberView.swift
//  BookBridge
//
//  Created by 이민호 on 3/12/24.
//

import SwiftUI

struct ConfirmPhoneNumberView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel = ChangePhonenumberViewModel()
    @State var showNextPage = false
    @Binding var verificationID: String
    @Binding var newPhoneNumber: String
    @Binding var showPhoneView: Bool
    
    var body: some View {
        ChangePhoneNumberStandardView(
            viewModel: viewModel,
            showNextPage: $showNextPage,
            showPhoneView: $showPhoneView
        )
        .navigationDestination(isPresented: $showNextPage) {
            
        }
        .onAppear() {            
            viewModel.setCertiNumberState(verificationID, newPhoneNumber)
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.backward")
                        .foregroundColor(.black)
                }
                
            }
        }
    }
}

//#Preview {
//    ConfirmPhoneNumberView()
//}

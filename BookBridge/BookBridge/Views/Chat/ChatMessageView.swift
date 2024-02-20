//
//  ChatMessageView.swift
//  BookBridge
//
//  Created by 이현호 on 2/6/24.
//

import SwiftUI

struct ChatMessageView: View {
    @Environment(\.dismiss) var dismiss
    
    @StateObject var viewModel = ChatMessageViewModel()
    
    @State var isAlarm: Bool = true
    
    @State private var isPlusBtn = true

    @FocusState var isShowKeyboard: Bool
    
    var chatRoomListId: String
    var noticeBoardTitle: String
    var chatRoomPartner: ChatPartnerModel
    var uid: String
    
    var body: some View {
        VStack {
            NoticeBoardChatView(viewModel: viewModel, chatRoomListId: chatRoomListId, noticeBoardId: chatRoomPartner.noticeBoardId, partnerId: chatRoomPartner.partnerId, uid: uid)
            
            MessageListView(viewModel: viewModel, partnerId: chatRoomPartner.partnerId, partnerImage: chatRoomPartner.partnerImage, uid: uid)
            
            if viewModel.noticeBoardInfo.state == 0 {
                //게시물 상태가 0
                ChatBottomBarView(viewModel: viewModel, isShowKeyboard: $isShowKeyboard, isPlusBtn: $isPlusBtn, chatRoomListId: chatRoomListId, partnerId: chatRoomPartner.partnerId, uid: uid)
            } else {
                if viewModel.noticeBoardInfo.reservationId != chatRoomPartner.partnerId && viewModel.noticeBoardInfo.userId == uid {
                    //게시물 작성자 == 나 이면서 예약자는 대화하고있는 사람이 아닌
                    if viewModel.noticeBoardInfo.state == 1 {
                        VStack(spacing: 10) {
                            Text("현재 \"\(viewModel.reservationName)\"님과 예약 진행중입니다.\n예약자를 변경하시겠습니까?")
                                .padding(.vertical, 8)
                                .padding(.horizontal, 12)
                                .font(.system(size: 20))
                                .foregroundStyle(Color(hex:"767676"))
                            
                            Button(action: {
                                viewModel.changeState(state: 1, partnerId: chatRoomPartner.partnerId, noticeBoardId: chatRoomPartner.noticeBoardId)
                            }) {
                                Text("확인")
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 12)
                                    .font(.system(size: 20, weight: .bold))
                                    .frame(maxWidth: .infinity)
                                    .foregroundStyle(.white)
                                    .background(Color(hex:"59AAE0"))
                                    .cornerRadius(10)
                                    .padding(.horizontal, 40)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 150)
                        .background(Color(.systemGray6))
                    } else {
                        VStack(spacing: 10) {
                            Text("\"\(viewModel.reservationName)\"님과 교환 완료했습니다.")
                                .padding(.vertical, 8)
                                .padding(.horizontal, 12)
                                .font(.system(size: 20))
                                .foregroundStyle(Color(hex:"767676"))
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 80)
                        .background(Color(.systemGray6))
                    }
                } else if viewModel.noticeBoardInfo.reservationId == uid || viewModel.noticeBoardInfo.userId == uid {
                    //게시물 작성자 == 나 이거나 예약자 == 대화하고있는 사람
                    ChatBottomBarView(viewModel: viewModel, isShowKeyboard: $isShowKeyboard, isPlusBtn: $isPlusBtn, chatRoomListId: chatRoomListId, partnerId: chatRoomPartner.partnerId, uid: uid)
                } else {
                    if viewModel.noticeBoardInfo.state == 1 {
                        Text("현재 다른 사람과 예약중입니다.")
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .font(.system(size: 20, weight: .bold))
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .foregroundStyle(.white)
                            .background(Color(.lightGray))
                    } else {
                        Text("다른 사람과 교환이 완료되었습니다.")
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .font(.system(size: 20, weight: .bold))
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .foregroundStyle(.white)
                            .background(Color(.lightGray))
                    }
                }
            }
        }
        .onTapGesture {
            withAnimation(.linear(duration: 0.2)) {
                isPlusBtn = true
            }
            isShowKeyboard = false
        }
        .transition(.move(edge: .bottom))
        //        .navigationTitle(noticeBoardTitle)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    viewModel.firestoreListener?.remove()
                    dismiss()
                } label: {
                    Image(systemName: "chevron.backward")
                        .foregroundStyle(.black)
                }
            }
            
            ToolbarItem(placement: .principal) {
                VStack {
                    HStack {
                        Image(systemName: "graduationcap.fill")
                            .font(.caption)
                            .foregroundStyle(.black)
                        Text(chatRoomPartner.style)
                            .font(.caption)
                            .foregroundStyle(.red)
                    }
                    Text(chatRoomPartner.nickname)
                        .font(.headline)
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button {
                        
                    } label: {
                        Text("신고하기")
                    }
                    
                    Button {
                        viewModel.changeAlarm(uid: uid, chatRoomListId: chatRoomListId, isAlarm: isAlarm)
                        isAlarm.toggle()
                    } label: {
                        if isAlarm {
                            Text("알림끄기")
                        } else {
                            Text("알림켜기")
                        }
                    }
                
                    Button(role: .destructive) {
                        
                    } label: {
                        Label("채팅방나가기", systemImage: "trash")
                    }
                    
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundColor(.black)
                }
            }
        }
        .onAppear {
            viewModel.initNewCount(uid: uid, chatRoomId: chatRoomListId)
            viewModel.fetchMessages(uid: uid, chatRoomListId: chatRoomListId)
            viewModel.getNoticeBoardInfo(noticeBoardId: chatRoomPartner.noticeBoardId)
        }
        .toolbar(.hidden, for: .tabBar)
    }
}

//
//  PostUserInfoView.swift
//  BookBridge
//
//  Created by 이민호 on 2/22/24.
//

import SwiftUI
import Kingfisher

struct PostUserInfoView: View {
    @StateObject var postViewModel: PostViewModel
    @EnvironmentObject private var pathModel: TabPathViewModel
    @Binding var noticeBoard: NoticeBoard
    
    var body: some View {
        HStack {
            KFImage(URL(string: postViewModel.user.profileURL ?? ""))
                .placeholder{
                    Image("Character")
                        .frame(width: 60, height: 60)
                        
                }
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 60, height: 60)
                .cornerRadius(30)
                .onTapGesture {
                    pathModel.paths.append(.mypage(other: UserModel(id: postViewModel.user.id, nickname: postViewModel.user.nickname, profileURL: postViewModel.user.profileURL, style: postViewModel.user.style, reviews: postViewModel.user.reviews)))
                }
           
            
            VStack {
                HStack {
                    Text((postViewModel.user.style == "" ? "칭호없음" : postViewModel.user.style) ?? "칭호없음")
                        .padding(.vertical, 5)
                        .padding(.horizontal, 8)
                        .font(.system(size: 12))
                        .foregroundStyle(Color(hex: "4B4B4C"))
                        .background(Color(hex: "D9D9D9"))
                        .cornerRadius(5)
                    
                    Spacer()
                    
                    Text("매너점수")
                        .font(.system(size: 12))
                    
                    Text(postViewModel.getMannerScore() == -1 ? "평점없음" : "\(postViewModel.getMannerScore())점")
                        .padding(.vertical, 5)
                        .padding(.horizontal, 8)
                        .font(.system(size: 12))
                        .foregroundStyle(Color(hex: "4B4B4C"))
                        .background(Color(hex: "FFD9E5"))
                        .cornerRadius(5)
                }
                
                HStack(alignment: .bottom) {
                    Text(postViewModel.user.nickname ?? "닉네임 미아")
                        .font(.system(size: 20, weight: .bold))
                        .onTapGesture {
                            pathModel.paths.append(.mypage(other: UserModel(id: postViewModel.user.id, nickname: postViewModel.user.nickname, profileURL: postViewModel.user.profileURL, style: postViewModel.user.style, reviews: postViewModel.user.reviews)))
                        }
                    
                    Spacer()
                    
                    Text(ConvertManager.getDong(address: noticeBoard.noticeLocationName) ?? "위치 없음")
                        .font(.system(size: 15))
                        .foregroundStyle(Color(hex: "767676"))
                }
            }
        }
        .padding(.horizontal)
    }
}

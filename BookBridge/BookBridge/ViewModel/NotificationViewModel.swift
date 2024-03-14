//
//  NotificationViewModel.swift
//  BookBridge
//
//  Created by 이현호 on 3/11/24.
//

import Foundation
import Firebase
import FirebaseFirestore

class NotificationViewModel: ObservableObject { 
    @Published var notifications: [NotificationModel] = []
    @Published var partnerImageUrl: String = ""
    
    var listener: ListenerRegistration?
    
    let db = Firestore.firestore()
}

//MARK: 상대방 평가 기능
extension NotificationViewModel {
    
    // 상대방 평가 시 정보 업데이트
    func updatePartnerReview(partnerId: String, reviewIndex: Int) {
        let partnerDocumentRef = FirebaseManager.shared.firestore.collection("User").document(partnerId)
        
        partnerDocumentRef.getDocument { documentSnapshot, error in
            guard let document = documentSnapshot else { return }
            
            var newReviews = document.data()?["reviews"] as? [Int] ?? [0, 0, 0]
            
            newReviews[reviewIndex] += 1
            
            let updatedData: [String: Any] = ["reviews": newReviews]
            
            partnerDocumentRef.updateData(updatedData) { error in
                guard error == nil else { return }
            }
        }
    }
    
    // 새로운 알림 평가정보 저장
    func saveNotification(notification: NotificationModel) {
        do {
            let documentRef = db.collection("User").document(notification.userId).collection("notification").document()
            try documentRef.setData(from: notification)
        } catch {
            print("Notification 저장실패")
        }
    }
}

//MARK: 실시간 알림 감지
extension NotificationViewModel {
    // Firestore에서 알림 변경 사항을 실시간으로 감지하는 메서드
    func startNotificationListener() {
        // 현재 사용자의 UID 가져오기
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        // 알림 리스너 설정
        listener = db.collection("User").document(uid).collection("notification")
            .order(by: "date", descending: true)
            .addSnapshotListener { [weak self] querySnapshot, error in
                    
                guard let documents = querySnapshot?.documents else { return }
                
                self?.notifications.removeAll()
                
                for document in documents {
                    let data = document.data()
                    let userId = data["userId"] as? String ?? ""
                    let noticeBoardId = data["noticeBoardId"] as? String ?? ""
                    let partnerId = data["partnerId"] as? String ?? ""
                    let noticeBoardTitle = data["noticeBoardTitle"] as? String ?? ""
                    let nickname = data["nickname"] as? String ?? ""
                    let timestamp = data["date"] as? Timestamp
                    let date = timestamp?.dateValue() ?? Date()
                    
                    FirebaseManager.shared.firestore.collection("User").document(partnerId).getDocument { [weak self] documentSnapshot, error in
                        guard let document = documentSnapshot, error == nil else { return }
                        let partnerImageUrl = document.data()?["profileURL"] as? String ?? ""
                        
                        // 메인 스레드에서 UI 업데이트
                        DispatchQueue.main.async {
                            let notification = NotificationModel(userId: userId, noticeBoardId: noticeBoardId, partnerId: partnerId, partnerImageUrl: partnerImageUrl, noticeBoardTitle: noticeBoardTitle, nickname: nickname, date: date)
                            self?.notifications.append(notification)
                            // 필요한 경우 notifications 배열을 정렬할 수 있습니다. 예: self?.notifications.sort(by: { $0.date > $1.date })
                        }
                    }
                }
            }
    }



}


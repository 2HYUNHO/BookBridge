
import SwiftUI
import Foundation

struct NoticeBoard: Identifiable,Hashable {
    //@DocumentID var id:
    var id = UUID().uuidString
    var userId: String
    var noticeBoardTitle: String
    var noticeBoardDetail: String
    var noticeImageLink: [String]
    var noticeLocation: [Double]        //index 0번은 위도, 1번은 경도
    var noticeLocationName: String      // 교환 희망 장소
    var isChange: Bool
    var state: Int                      //게시물 상태) 0 = 아무것도 없음, 1 = 예약중, 2 = 교환완료
    var date: Date
    var hopeBook: [Item]
    var geoHash: String?
    var reservationId: String? 
    var isAddLocation: Bool?

    var dictionary: [String: Any] {
        return [
            "noticeBoardId": id,
            "userId": userId,
            "noticeBoardTitle": noticeBoardTitle,
            "noticeBoardDetail": noticeBoardDetail,
            "noticeImageLink": noticeImageLink,
            "noticeLocation": noticeLocation,
            "noticeLocationName": noticeLocationName,
            "isChange": isChange,
            "state": state,
            "date": date,
            "geoHash": geoHash ?? "",
            "reservationId": reservationId ?? "",
            "isAddLocation": isAddLocation ?? false
        ]
    }
}

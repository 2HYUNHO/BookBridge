//
//  EmailError.swift
//  BookBridge
//
//  Created by 이민호 on 2/2/24.
//

import Foundation

enum EmailError: String {
    case invalid = "잘못된 이메일 형식입니다."
    case redundant = "이미 가입한 이메일 입니다."    
    case success = "이메일 인증이 완료되었습니다."
    
    func getColor() -> String {
        switch self {
        case .invalid:
            return "F80B0B"
        case .redundant:
            return "F80B0B"
        case .success:
            return "0A84FF"
        }
    }
}
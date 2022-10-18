//
//  NetworkEntitiy.swift
//  Blamarket
//
//  Created by yangjs on 2022/08/24.
//

import Foundation
protocol Entity {
    associatedtype Item:Decodable
}
// -MARK: 유저 공통 Response데이터 모델
struct UserNetworkEntity<R:Decodable> : Decodable,Entity{
    typealias Item = R
    let status : Int
    let message : String
    let result : Item
    
}
// -MARK: 로그인 관련 데이터 모델
struct LoginResultData : Decodable{
    let resultData : UserInfo
    enum CodingKeys: String,CodingKey{
        case resultData = "data"
    }
}

struct UserInfo: Decodable{
    let email: String
    let company: String
    let name : String
    let isEnable : String
    enum CodingKeys: String,CodingKey{
        case email,company,name
        case isEnable = "is_enable"
    }
}


/*
{
    "status": 200,
    "message": "scccess",
    "result": {
        "data": {
            "email": "didwns7347@naver.com",
            "company": "Markany",
            "name": "자이언트 바퀴벌레",
            "is_enable": "Y"
        }
    }
}
*/
// MARK: 인증코드 전송 관련
// MARK: 회원가입 관련
struct User: Decodable{
    let email: String?
    let name: String?
    let company: String?
}
struct RegistResultData: Decodable{
    let resultData : User?
    enum CodingKeys: String,CodingKey{
        case resultData = "data"
    }
}

struct CommonResultData : Decodable{
    let status:String
    let message:String
}

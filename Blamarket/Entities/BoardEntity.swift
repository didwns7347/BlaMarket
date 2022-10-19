//
//  BoardEntity.swift
//  Blamarket
//
//  Created by yangjs on 2022/10/17.
//

import Foundation

// -MARK: 유저 공통 Response데이터 모델
struct BoardNetworkEntity<R:Decodable> : Decodable,Entity{
    typealias Item = R
    let status : Int
    let message : String
    let result : Item
    
}

struct PostEntity : Decodable{
    let id: Int
    let title : String
    let content : String
    let thumbnail : String
    let price : String
    let createDate : String
    let usedDate : String
    let viewCount : String
    
    enum CodingKeys: String,CodingKey{
        case id,title,content,thumbnail,price,usedDate
        case createDate = "date"
        case viewCount = "viewCnt"
    }
}

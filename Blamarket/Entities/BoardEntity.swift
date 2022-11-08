//
//  BoardEntity.swift
//  Blamarket
//
//  Created by yangjs on 2022/10/17.
//

import Foundation

// -MARK: 유저 공통 Response데이터 모델
struct PostNetworkEntity<R:Decodable> : Decodable,Entity{
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
    let price : Int
    let createDate : String
    let usedDate : String?
    let viewCount : String?
    
    enum CodingKeys: String,CodingKey{
        case id,title,content,thumbnail,price
        case createDate = "date"
        case viewCount = "view_count"
        case usedDate = "used_date"
    }
}


struct PostDetailEntity: Decodable{
    let id : Int
    let title: String
    let images: [String]
    let price : String
    let date: String
    let email: String
    let viewCount:Int
    let category: String
    let wish:Bool
    let content: String
    
}

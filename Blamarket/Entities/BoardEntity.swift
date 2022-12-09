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
    let email: String
    let title: String
    let content: String
    let price : Int?
    let date: String
    let viewCount:String?
    let category: String
//    let wish: Dictionary
    let images: [String]
   
    enum CodingKeys: String,CodingKey{
        
        case id,email,title,content,price,date,category,images
        case viewCount = "view_count"
    }
}
/**
 id": 32529,
 "email": "firejs123@naver.com",
 "title": "폴더생성테스트",
 "content": "폴더생성테스트다이말이야",
 "price": 123456,
 "used_date": null,
 "date": "2022-12-04",
 "status": null,
 "view_count": null,
 "category": "4",
 "images":[
 "/usr/local/tomcat/temp/test/32529/mountain_1.jpg",
 "/usr/local/tomcat/temp/test/32529/mountain_2.jpg",
 "/usr/local/tomcat/temp/test/32529/mountain_3.jpg"
 ],
 "wish":{
 }
 }
 */

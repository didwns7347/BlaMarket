//
//  NetworkEntitiy.swift
//  Blamarket
//
//  Created by yangjs on 2022/08/24.
//

import Foundation
protocol Entity : Decodable{
    
}

struct NetworkModel : Decodable{
    let status : String
    let message : String
    let result :ResultData
    
}

struct ResultData : Decodable{
    let resultData : User
    enum CodingKeys: String,CodingKey{
        case resultData = "data"
    }
}

struct User: Decodable{
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

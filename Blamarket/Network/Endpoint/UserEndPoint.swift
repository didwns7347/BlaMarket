//
//  UserEndPoint.swift
//  Blamarket
//
//  Created by yangjs on 2022/08/24.
//

import Foundation

struct UserEndPoint {
    
    static func login(email:String, password: String) -> Endpoint<UserNetworkEntity<LoginResultData>>{
        let loginModel = LoginModel(email: email, password: password)
        return Endpoint(baseURL: UserConst.USER_SERVER_URL,
                        path: "/login",
                        method: .post,
                        queryParameters: nil,
                        bodyParameters: loginModel,
                        headers: nil,
                        sampleData: nil)
    }
    
    static func requestAuthCode(email:String) -> Endpoint<UserNetworkEntity<[String:String]>>{
        //let queryParameters = ["email":email]
        return Endpoint(baseURL: UserConst.USER_SERVER_URL,
                        path:"/auth/\(email)",
                        method: .get,
                        queryParameters: nil,
                        bodyParameters: nil,
                        headers: nil,
                        sampleData:nil
                        )
    }
    
    static func requestCheckAuthCode(code:String,email:String)->Endpoint<UserNetworkEntity<[String:String]>>{
        //let queryParameters = ["authCode":code]
        return Endpoint(baseURL: UserConst.USER_SERVER_URL,
                        path:"/auth/\(email)/\(code)",
                        method: .get,
                        queryParameters: nil,
                        bodyParameters: nil,
                        headers: nil,
                        sampleData:nil
                        )
    }
    
    static func register(nickname:String, email:String, pw: String)->Endpoint<UserNetworkEntity<RegistResultData>>{
        let body = ["email":email, "password":pw, "name":nickname]
        return Endpoint(baseURL: UserConst.USER_SERVER_URL,
                        path: "/user/",
                        method: .post,
                        queryParameters: nil,
                        bodyParameters: body,
                        headers: nil,
                        sampleData: nil
                        )
        
    }
}

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
                        path: "/user/login",
                        method: .post,
                        queryParameters: nil,
                        bodyParameters: loginModel,
                        headers: nil,
                        sampleData: nil)
    }
    
    static func requestAuthCode(email:String) -> Endpoint<UserNetworkEntity<[String:String]>>{
        let queryParameters = ["email":email]
        return Endpoint(baseURL: UserConst.USER_SERVER_URL,
                        path:"/user/auth",
                        method: .get,
                        queryParameters: queryParameters,
                        bodyParameters: nil,
                        headers: nil,
                        sampleData:nil
                        )
    }
    
    static func requestCheckAuthCode(code:String)->Endpoint<UserNetworkEntity<[String:String]>>{
        let queryParameters = ["authCode":code]
        return Endpoint(baseURL: UserConst.USER_SERVER_URL,
                        path:"/user/auth",
                        method: .put,
                        queryParameters: queryParameters,
                        bodyParameters: nil,
                        headers: nil,
                        sampleData:nil
                        )
    }
}

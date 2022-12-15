//
//  UserEndPoint.swift
//  Blamarket
//
//  Created by yangjs on 2022/08/24.
//

import Foundation

struct UserEndPoint {
    /**
     로그인 정보 가져오기
     */
//    static func getLoginInfo(token:String) -> Endpoint<UserNetworkEntity<LoginResultData>>{
//
//        return Endpoint(baseURL: UserConst.USER_SERVER_URL,
//                        path: "/user/jwt-user",
//                        method: .get,
//                        queryParameters: nil,
//                        bodyParameters: nil,
//                        headers: [UserConst.jwtToken: token],
//                        sampleData: nil)
//    }
    
    static func login(email:String, password: String) -> Endpoint<UserNetworkEntity<LoginResultData>>{
        let loginModel = LoginModel(email: email, password: password)
        return Endpoint(baseURL: UserConst.SERVER_URL,
                        path: "/login",
                        method: .post,
                        queryParameters: nil,
                        bodyParameters: loginModel,
                        headers: nil,
                        sampleData: nil)
    }
    
    static func requestAuthCode(email:String) -> Endpoint<UserNetworkEntity<[String:String]>>{
        //let queryParameters = ["email":email]
        return Endpoint(baseURL: UserConst.SERVER_URL,
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
        return Endpoint(baseURL: UserConst.SERVER_URL,
                        path:"/auth/\(email)/\(code)",
                        method: .get,
                        queryParameters: nil,
                        bodyParameters: nil,
                        headers: nil,
                        sampleData:nil
                        )
    }
    
    /**
     jwt 토큰 갱신
     */
    static func updateToken(token:String)->Endpoint<UserNetworkEntity<[String:String]>>{
        let header = [UserConst.jwtToken : token]
        return Endpoint(baseURL: UserConst.SERVER_URL,
                        path:"/user/token",
                        method: .get,
                        queryParameters: nil,
                        bodyParameters: nil,
                        headers: header,
                        sampleData:nil
                        )
    }
    
    static func register(nickname:String, email:String, pw: String)->Endpoint<UserNetworkEntity<RegistResultData>>{
        let body = ["email":email, "password":pw, "name":nickname]
        let header = ["Content-Type":"application/json"]
        return Endpoint(baseURL: UserConst.SERVER_URL,
                        path: "/user",
                        method: .post,
                        queryParameters: nil,
                        bodyParameters: body,
                        headers: header,
                        sampleData: nil
                        )
        
    }
    
    static func editProfile(profileModel:ProfileModel) -> Endpoint<UserNetworkEntity<CommonResultData>>{
        let header = ["Content-Type":"application/json", NetworkConst.TokenHeaderKey:NetworkConst.authorization ]
//        let body = profileModel.
        return Endpoint(baseURL: PostConst.SERVER_URL,
                        path: "/user/profile",
                        method: .post,
                        queryParameters: nil,
                        bodyParameters: ["name":profileModel.name] ,
                        headers: ["Content-Type":"multipart/form-data; boundary=\(PostEndPoint.boundary)",
                                  NetworkConst.TokenHeaderKey:NetworkConst.authorization
                                 ],
                        sampleData: nil,
                        uploadImages: [profileModel.profileImage!])
    }
}

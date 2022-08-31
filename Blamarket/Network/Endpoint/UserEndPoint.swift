//
//  UserEndPoint.swift
//  Blamarket
//
//  Created by yangjs on 2022/08/24.
//

import Foundation

struct UserEndPoint {
    
    static func login(email:String, password: String) -> Endpoint<UserNetworkEntity>{
        let loginModel = LoginModel(email: email, password: password)
        return Endpoint(baseURL: UserConst.USER_SERVER_URL,
                        path: "/user/login",
                        method: .post,
                        queryParameters: nil,
                        bodyParameters: loginModel,
                        headers: nil,
                        sampleData: nil)
    }
}

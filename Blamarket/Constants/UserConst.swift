//
//  UserConst.swift
//  Blamarket
//
//  Created by yangjs on 2022/08/19.
//

import Foundation
import UIKit
struct UserConst{
    static let SERVER_URL = "http://112.171.104.167:58081/blamarket-0.0.1-SNAPSHOT-plain"
    static let ID_REGEX = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    static let PW_REGEX =  "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&])(?=.*[0-9])[A-Za-z\\d$@$!%*?&]{8}"
    static let ID_INPUT_ERROR = "근무중인 회사 이메일 주소를 입력해 주세요"
    static let PW_INPUT_ERROR = "비밀번호 최소 8자리 이상 : 영어 대문자, 소문자, 숫자, 특수문자 포함"
    static let SUCCESS = "success"
    //Network 관련
    static let Login_Path = "/login"
    static let RequestAuth_Code_Path = ""
    static let LAST_TOKEN_DATE = "lastTokenDate"
    //자동로그인 7주일기준
    static let Login_Alive_Time = 7
    //키체인 로그인 토큰
    static let Authorize_key = "Authorize"
    static let Company = "companyName"
    
    static let AccessToken = "accessToken"
    static let jwtToken = ""
    
    //UserDefaults
    static let loginedID = "email"
    static let companyID = "companyID"
    static let userName = "name"
}
struct ColorConst{
    static let MAIN_COLOR = UIColor.systemBlue
}

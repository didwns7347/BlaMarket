//
//  UserConst.swift
//  Blamarket
//
//  Created by yangjs on 2022/08/19.
//

import Foundation
import UIKit
struct UserConst{
    static let USER_SERVER_URL = "http://121.140.253.36:28080/blamarket-0.0.1-SNAPSHOT-plain"
    static let ID_REGEX = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    static let PW_REGEX =  "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&])(?=.*[0-9])[A-Za-z\\d$@$!%*?&]{8}"
    static let ID_INPUT_ERROR = "근무중인 회사 이메일 주소를 입력해 주세요"
    static let PW_INPUT_ERROR = "비밀번호 최소 8자리 이상 : 영어 대문자, 소문자, 숫자, 특수문자 포함"
    static let SUCCESS = "success"
    //Network 관련
    static let Login_Path = "/login"
    static let RequestAuth_Code_Path = ""
}
struct ColorConst{
    static let MAIN_COLOR = UIColor.systemBlue
}

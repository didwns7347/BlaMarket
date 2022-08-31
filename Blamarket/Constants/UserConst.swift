//
//  UserConst.swift
//  Blamarket
//
//  Created by yangjs on 2022/08/19.
//

import Foundation
import UIKit
struct UserConst{
    static let USER_SERVER_URL = "https://28753bf1-f222-4072-ad13-a996aa2c0202.mock.pstmn.io"
    static let ID_REGEX = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    static let PW_REGEX =  "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&])(?=.*[0-9])[A-Za-z\\d$@$!%*?&]{8}"
    static let ID_INPUT_ERROR = "근무중인 회사 이메일 주소를 입력해 주세요"
    static let PW_INPUT_ERROR = "최소 8자리 이상 : 영어 대문자, 소문자, 숫자, 특수문자 포함"
}
struct ColorConst{
    static let MAIN_COLOR = UIColor.systemBlue
}

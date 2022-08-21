//
//  UserConst.swift
//  Blamarket
//
//  Created by yangjs on 2022/08/19.
//

import Foundation
struct UserConst{
    static let ID_REGEX = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    static let PW_REGEX =  "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&])(?=.*[0-9])[A-Za-z\\d$@$!%*?&]{8}"
    
}

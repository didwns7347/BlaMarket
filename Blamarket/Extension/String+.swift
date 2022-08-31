//
//  String+.swift
//  Blamarket
//
//  Created by yangjs on 2022/08/31.
//

import Foundation
extension String{
    
    /**
        문자열이 이메일 포멧인지 확인
     */
    func isEmailFormat() -> Bool{
        return self.range(of: UserConst.ID_REGEX, options: .regularExpression) != nil
    }
    /**
     문자열이 비밀번호 포멧인지 확인
     */
    func isPasswordFormat() -> Bool{
        return self.range(of: UserConst.PW_REGEX, options: .regularExpression) != nil
    }
}

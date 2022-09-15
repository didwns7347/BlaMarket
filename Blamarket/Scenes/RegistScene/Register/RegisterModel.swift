//
//  RegisterModel.swift
//  Blamarket
//
//  Created by yangjs on 2022/09/13.
//

import Foundation
enum InputError:String{
    case nicknameLength
    case passwordPolicy
    case passwordEqual
    case unkown
    func desciption()->String{
        switch self{
        case.nicknameLength:
            return "닉네임은 1글자 이상 8글자 이하로 입력해 주세요"
        case.passwordEqual:
            return "비밀번호가 일치하지 않습니다."
        case .passwordPolicy:
            return UserConst.PW_INPUT_ERROR
        default:
            return "다시 시도해 주세요"
        }

    }
}

struct RegisterModel{
    
    //인풋값들이 적절한지 필터링
    func inputInvalid(info:(String,String,String,String)) -> String {
        if 1>info.0.count || info.0.count>8{
            return InputError.passwordPolicy.desciption()
        }
        
        if info.1 != info.2{
            return InputError.passwordEqual.desciption()
        }
        
        if !info.1.isPasswordFormat(){
            return InputError.passwordPolicy.desciption()
        }
        return ""
    }
}

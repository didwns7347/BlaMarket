//
//  LoginVIewModel.swift
//  Blamarket
//
//  Created by yangjs on 2022/08/17.
//

import RxCocoa
import RxSwift
import Combine
import Foundation


struct LoginInfo{
    let id : String
    let pw : String
}
struct LoginViewModel {
    var id = PublishRelay<String>()
    var pw = PublishRelay<String>()
    var presentAlert : Signal<Alert>
    //var loginResult : Observable<LoginResult>()
    
    var loginButtonTapped = PublishRelay<Void>()
    init(){
        let loginInfo = Observable.combineLatest(id,pw){id, pw -> LoginInfo in
            return LoginInfo(id: id, pw: pw)
        }
        
        let loginInputCheck = loginButtonTapped.withLatestFrom(loginInfo)
            .map{ info -> (info:LoginInfo, message:String) in
                let id = info.id
                let pw = info.pw
                print("Email = \(id) passwd: = \(pw)")
              
             
                if id.range(of: UserConst.ID_REGEX, options: .regularExpression) == nil{
                    return (info:info, message:"이메일 주소를 입력해 주세요")
                }
                if pw.range(of: UserConst.PW_REGEX, options: .regularExpression) == nil{
                    return (info:info, message:"잘못된 비밀번호 입니다.")
                }
                return (info:info, message:"")
            }
        
        self.presentAlert = loginInputCheck
            .filter{!$1.isEmpty}
            .map{_,message -> (title:String, message: String) in
                return (title:"실패",message:message)
            }
            .asSignal(onErrorSignalWith: .empty())
        
        
//        var loginResult = loginInputCheck
//            .filter{$1.isEmpty}
//            .filter { (info: LoginInfo, message: String) -> Single<Bool> in
//                return Single.create{ observer -> Disposable in
//
//                }
//            }
//
        
        
        
        
        
        
        
        
    }
    
    
}

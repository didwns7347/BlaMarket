//
//  EmailAuthViewModel.swift
//  Blamarket
//
//  Created by yangjs on 2022/08/31.
//

import Foundation
import RxSwift
import RxCocoa
struct EmailAuthViewModel
{
    let bag = DisposeBag()
    let inputEmail = PublishRelay<String>()
    let sendCode = PublishRelay<Void>()
    let inputValid = PublishRelay<String>()
    let inputInvalid = PublishRelay<Alert>()
    init(){
        sendCode.withLatestFrom(inputEmail)
            .filter(EmailAuthViewModel.checkEmailPolicy)
            .bind(to: inputValid)
            .disposed(by: bag)
        
        sendCode.withLatestFrom(inputEmail)
            .filter{
                EmailAuthViewModel.checkEmailPolicy(email: $0) == false
            }
            .map{ _ -> Alert in
                return (title:"",message:UserConst.ID_INPUT_ERROR)
            }
            .bind(to:inputInvalid)
            .disposed(by: bag)
        
        
    }
    /**
        인풋이 이메일인지 확인.
     */
    static func checkEmailPolicy(email:String)-> Bool{
        return email.range(of: UserConst.ID_REGEX, options: .regularExpression) != nil
    }
}

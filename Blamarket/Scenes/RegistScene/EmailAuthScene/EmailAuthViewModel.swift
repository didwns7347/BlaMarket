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

        inputEmail.subscribe{
            print($0)
        }.disposed(by: bag)
        
        sendCode.withLatestFrom(inputEmail)
            .filter{$0.isEmailFormat()}
            .bind(to: inputValid)
            .disposed(by: bag)
        
        //이메일 주소 정책 필터링
        sendCode.withLatestFrom(inputEmail)
            .filter{
                print($0)
                return $0.isEmailFormat() == false
            }
            .map{ _ -> Alert in
                return (title:"실패",message:UserConst.ID_INPUT_ERROR)
            }
            .bind(to:inputInvalid)
            .disposed(by: bag)
 
    }
    


}

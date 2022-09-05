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
    //서버에 이메일로 인증코드 전송 요청
    let sendCode = PublishRelay<Void>()
    //이메일 인풋 체크
    let inputValid = PublishRelay<String>()
    let inputInvalid = PublishRelay<Alert>()
    
    //입력받은 인증번호 서버 전송
    let checkAuthCodeTapped = PublishRelay<Void>()
    let authCodeInput = PublishRelay<String>()
    
    let requestMailCode : Signal<(Bool,String?)>
    let requestCheckAuthCode : Signal<(Bool,String?)>
    init(){
        sendCode.withLatestFrom(inputEmail)
            .filter{$0.isEmailFormat()}
            .bind(to: inputValid)
            .disposed(by: bag)
        
        //이메일 주소 정책 필터링
        sendCode.withLatestFrom(inputEmail)
            .filter{
                return $0.isEmailFormat() == false
            }
            .map{ _ -> Alert in
                return (title:"실패",message:UserConst.ID_INPUT_ERROR)
            }
            .bind(to:inputInvalid)
            .disposed(by: bag)
        /**
         이메일 인증 코드 전송 요청
         */
        let requestAuthCodeResult = inputValid
            .flatMapLatest{ email -> Single<Result<UserNetworkEntity<[String:String]>,Error>> in
                print("USER EMAIL = [\(email.trimmingCharacters(in: [" "]))]")
                let endpoint = UserEndPoint.requestAuthCode(email: email.trimmingCharacters(in: [" "]))
                let userNetwork = NetworkProvider()
                return userNetwork.request(with: endpoint)
            }.share()
            
        requestMailCode = requestAuthCodeResult
            .map { result  -> (Bool,String?) in
                switch result{
                case .success(let data):
                    if data.status == 200, data.message == UserConst.SUCCESS{
                        return (true,nil)
                    }else{
                        return (false, data.message)
                    }
                    
                case .failure(let error):
                    return (false ,error.localizedDescription)
                }
            }.asSignal(onErrorJustReturn: (false, "잠시후 다시 시도해 주세요"))
        
         // MARK: 인증코드 확인 로직
        let checkAuthCodeResult = checkAuthCodeTapped.withLatestFrom(authCodeInput)
            .map{$0}
            .flatMapLatest{ code -> Single<Result<UserNetworkEntity<[String:String]>,Error>> in
                print("authCode = [\(code)]")
                let endPoint = UserEndPoint.requestCheckAuthCode(code: code)
                let userNetwork = NetworkProvider()
                return userNetwork.request(with: endPoint)
            }.share()
        
        self.requestCheckAuthCode = checkAuthCodeResult
            .map { result  -> (Bool,String?) in
                switch result{
                case .success(let data):
                    if data.status == 200, data.message == UserConst.SUCCESS{
                        return (true,nil)
                    }else{
                        return (false, data.message)
                    }
                    
                case .failure(let error):
                    return (false ,error.localizedDescription)
                }
            }.asSignal(onErrorJustReturn: (false, "잠시후 다시 시도해 주세요"))
        
    }


}

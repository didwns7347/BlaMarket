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
import UIKit



struct LoginViewModel {
    let bag = DisposeBag()
    
    var id = PublishRelay<String>()
    var pw = PublishRelay<String>()
    var presentAlert : Signal<Alert>
    //var loginResult : Single<Result<UserNetworkEntity,Error>>
    //var loginResult : Observable<LoginResult>()
   
    var loginButtonTapped = PublishRelay<Void>()
    let loginSuccess : Observable<UserNetworkEntity<LoginResultData>>
    let goMainPage : Signal<Bool>
    let emailAuthViewModel = EmailAuthViewModel()
    
    let loginInputCheckSuccess = PublishRelay<Bool>()
    init(){
        let loginInfo = Observable.combineLatest(id,pw){id, pw -> LoginModel in
            return LoginModel(email: id, password: pw)
        }
        
        let loginInputCheck = loginButtonTapped.withLatestFrom(loginInfo)
            .map{ info -> (info:LoginModel, message:String) in
                let id = info.email
                let pw = info.password
                print("Email = \(id) passwd: = \(pw)")
                if !id.isEmailFormat(){
                    return (info:info, message:UserConst.ID_INPUT_ERROR)
                }
                if !pw.isPasswordFormat(){
                    return (info:info, message:UserConst.PW_INPUT_ERROR)
                }
                return (info:info, message:"")
            }
        loginInputCheck
            .map{
                $0.message.isEmpty
            }.filter{$0}
            .bind(to: loginInputCheckSuccess)
            .disposed(by: bag)
    
   
        let inputError = loginInputCheck
            .filter{!$1.isEmpty}
            .map{_,message ->String  in
                return message
            }
         
        
        
        let loginResult = loginInputCheck
            .filter{$1.isEmpty}
            .map{$0.info}
            .flatMap{ loginInfo -> Single<Result<UserNetworkEntity<LoginResultData>,Error>> in
                let endpoint = UserEndPoint.login(email: loginInfo.email, password: loginInfo.password)
                let userNetwork = NetworkProvider()
                return userNetwork.request(with: endpoint)
            }.share()
        
        loginSuccess = loginResult.compactMap { data -> UserNetworkEntity<LoginResultData>? in
            guard case let .success(value) = data else{
                return nil
            }
            return value
        }
        
        goMainPage = loginSuccess.map{_ -> Bool in
            return true
        }.asSignal(onErrorJustReturn: false)
        
        let loginError = loginResult.compactMap { data -> String? in
            switch data{
            case .failure(let error) :
                return error.localizedDescription
            default :
                return nil
            }
        }
        
        self.presentAlert = Observable.merge(inputError,loginError)
            .map{message -> Alert in
                return (title:"실패", message:message)
            }.asSignal(onErrorJustReturn:  (title:"실패", message:"잠시후 다시 시도해 주세요"))
      
        
 
    }
    
    
}

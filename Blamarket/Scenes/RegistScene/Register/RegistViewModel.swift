//
//  RegistViewModel.swift
//  Blamarket
//
//  Created by yangjs on 2022/08/19.
//

import Foundation
import RxCocoa
import RxSwift

struct RegistViewModel {
    let bag = DisposeBag()
  
    let nicknameInput = PublishRelay<String>()
    let pwInput = PublishRelay<String>()
    let pwCheckInput = PublishRelay<String>()
    let submitButtonTapped = PublishRelay<Void>()
    
    let inputs = PublishRelay<(String,String,String,String)>()
    let email = PublishSubject<String>()
    
    let inputUnvalid = PublishRelay<Alert>()
    let inputValid = PublishRelay<Void>()
    
    let requestRegistResult : Signal<(Bool,String?)>
    
    init(model: RegisterModel = RegisterModel()){
        PublishRelay.combineLatest(nicknameInput,pwInput,pwCheckInput,email)
            .bind(to: inputs)
            .disposed(by: bag)
        
   
        
        
        
        submitButtonTapped.bind(onNext: {
            print("tapped !!")
        }).disposed(by: bag)
        
        let inputs = submitButtonTapped.withLatestFrom(inputs)
        
        inputs.map(model.inputInvalid)
            .filter{!$0.isEmpty}
            .map{ title -> Alert in
                return (title:title, message:nil)
            }.bind(to: inputUnvalid)
            .disposed(by: bag)
        
        let inputValid = inputs.map(model.inputInvalid)
            .filter{$0.isEmpty}
            
        
        let registerResult = inputValid.withLatestFrom(inputs)
            .flatMap{ info -> Single<Result<UserNetworkEntity<RegistResultData>,Error>> in
                let endpoint = UserEndPoint.register(nickname: info.0, email: info.3, pw: info.1)
                let userNetwork = NetworkProvider()
                return userNetwork.request(with: endpoint)
            }.share()
        registerResult.subscribe(onNext:{
            print($0)
        }).disposed(by: bag)
        
        requestRegistResult = registerResult
            .map{result -> (Bool, String?) in
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
            }.asSignal(onErrorJustReturn: (false,"잠시후 다시 시도해 주세요"))
    }
    
    
    
    
}

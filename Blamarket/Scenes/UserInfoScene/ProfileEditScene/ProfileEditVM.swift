//
//  ProfileEditVM.swift
//  Blamarket
//
//  Created by yangjs on 2022/12/13.
//

import Foundation
import RxCocoa
import RxSwift

class ProfileEditVM {
    let bag = DisposeBag()
    let userInfo : Single<ProfileModel>
    
    let profileImageDelete = PublishSubject<Void>()
    
    var selectedProfileAction = PublishSubject<ProfileAction>()
    
    var albumSelected = PublishRelay<ProfileAction>()
    var profileSubmitted = PublishSubject<ProfileModel>()
    var lodingControl = BehaviorRelay<Bool>(value: false)
    
    let profileEditFinished = PublishRelay<String?>()
    let showAelrt = PublishRelay<Alert>()
    init(){
        userInfo = Single.just(ProfileModel(
            profileImageURL: "https://github.com/ReactiveX/RxSwift/raw/main/assets/RxSwift_Logo.png",
            name: "자이언트바퀴벌래", profileImage: nil))
        
        selectedProfileAction
            .filter{$0 == .Album}
            .bind(to: albumSelected)
            .disposed(by: bag)
        
        selectedProfileAction
            .filter{$0 == .delete}
            .map{_ in ()}
            .bind(to: profileImageDelete)
            .disposed(by: bag)
        
        let submiited = profileSubmitted
            .debug()
            .distinctUntilChanged { lsh, rsh in
                lsh.profileImage == rsh.profileImage && lsh.name == rsh.name
            }
        
        submiited
            .subscribe(onNext:{[weak self] model in
                print(model)
                self?.lodingControl.accept(true)
                
            }).disposed(by: bag)
        
//        let profileRequset = NetworkProvider()
//        profileRequset.request(with: )
        
        submiited
            .flatMap(requestProfile)
            .map{ result -> String? in
                switch result{
                case .success( _ ):
                    return nil
                case .failure(let error):
                    return error.localizedDescription
                }
            }.bind(to: self.profileEditFinished)
            .disposed(by: bag)
        
        profileEditFinished
            .compactMap{$0}
            .map{ title -> Alert in
                Alert(title:title, message:nil)
            }
            .bind(to: self.showAelrt)
            .disposed(by: bag)
        
        
        
        
        
    }
    
    func requestProfile(model: ProfileModel) -> Single<Result<UserNetworkEntity<CommonResultData>,Error>>{
        let endPoint = UserEndPoint.editProfile(profileModel: model)
        return NetworkProvider().request(with: endPoint)
    }
}

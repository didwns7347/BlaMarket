//
//  ProfileEditVM.swift
//  Blamarket
//
//  Created by yangjs on 2022/12/13.
//

import Foundation
import RxCocoa
import RxSwift

struct ProfileEditVM {
    let bag = DisposeBag()
    let userInfo : Single<ProfileModel>
    
    let profileImageDelete = PublishSubject<Void>()
    
    var selectedProfileAction = PublishSubject<ProfileAction>()
    
    var albumSelected = PublishRelay<ProfileAction>()
    init(){
        userInfo = Single.just(ProfileModel(
            profileImage: "https://github.com/ReactiveX/RxSwift/raw/main/assets/RxSwift_Logo.png",
            name: "자이언트바퀴벌래"))
        
        selectedProfileAction
            .filter{$0 == .Album}
            .bind(to: albumSelected)
            .disposed(by: bag)
        
        selectedProfileAction
            .filter{$0 == .delete}
            .map{_ in ()}
            .bind(to: profileImageDelete)
            .disposed(by: bag)
        
        
    }
}

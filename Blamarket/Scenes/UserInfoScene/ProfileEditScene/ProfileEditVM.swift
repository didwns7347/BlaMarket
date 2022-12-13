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
    let userInfo : Single<ProfileModel>
    
    init(){
        userInfo = Single.just(ProfileModel(
            profileImage: "https://github.com/ReactiveX/RxSwift/raw/main/assets/RxSwift_Logo.png",
            name: "자이언트바퀴벌래"))
        
    }
}

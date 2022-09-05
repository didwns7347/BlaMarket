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
    let email : Observable<String>
    
    init(authEmail : String){
        email = Observable.just(authEmail)
    }
    
}

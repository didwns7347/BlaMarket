//
//  MainViewModel.swift
//  Blamarket
//
//  Created by yangjs on 2022/08/24.
//

import Foundation
import RxSwift
import RxCocoa

class MainViewModel {
    var currentPage = 0
    var lastPage = 20
    
    let bag = DisposeBag()
    let postList = BehaviorRelay<[PostEntity]>(value: [])
    let loadPost = PublishSubject<Void>()
    
    
    init(){
        bind()
    }
    
    private func bind(){
        loadPost.subscribe{ [weak self] _ in
            self?.getPost()
        }.disposed(by: bag)
    }
    
    private func getPost(){
        
    }
}

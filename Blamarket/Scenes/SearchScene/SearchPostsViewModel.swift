//
//  SearchPostsViewModel.swift
//  Blamarket
//
//  Created by yangjs on 2022/10/21.
//

import Foundation
import RxSwift
import RxCocoa

struct SearchPostsViewModel{
    let storage = CoreDataStorage()
    let requestLoadData = PublishSubject<Void>()
    let searchRecodes = BehaviorSubject<[SearchRecode]>(value: [])
    let recodeDeleteRequset = PublishSubject<SearchRecode>()
    let bag = DisposeBag()
    
    let keywordSelected = PublishSubject<String>()
    let recordListSelected = PublishSubject<SearchRecode>()
    
    init(){
        bind()
    }
    func bind(){
        requestLoadData.subscribe(onNext:{_ in
            getKetwordList()
        }).disposed(by: bag)
        
        recodeDeleteRequset.subscribe(onNext: {recode in
            storage.deleteData(recode: recode)
        }).disposed(by: bag)
        
        keywordBind()
    }
    
    func keywordBind(){
        keywordSelected.subscribe(onNext:{
            print($0)
            saveKeyword(keyword: $0)
        })
        .disposed(by: bag)
        
//        recordListSelected.compactMap{$0.keyword}
//            .bind(to: keywordSelected)ㅇㅇㅇ
//            .disposed(by: bag)
    }
    
    func saveKeyword(keyword:String){
        if storage.searchAndDelete(keyword: keyword){
            print("\(keyword) is 중복 키워드")
        }
        storage.saveData(data: keyword)
        requestLoadData.onNext(())
    }
    
    func getKetwordList(){
        searchRecodes.onNext(storage.fetchData().sorted(by: { $0.date! > $1.date!
        }))
    }
    
}

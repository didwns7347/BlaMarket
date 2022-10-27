//
//  MainViewModel.swift
//  Blamarket
//
//  Created by yangjs on 2022/08/24.
//

import Foundation
import RxSwift
import RxCocoa
struct LoadParameter{
    let pageNum: Int
    let category: Category?
    let keyword: String?
    
}
class MainViewModel {
    var currentPage = 1
    var lastPage = 20
    
    let bag = DisposeBag()
    //테이블뷰 페이징 관련
    let postList = BehaviorRelay<[PostEntity]>(value: [])
    let loadMorePost = PublishSubject<Void>()
    let loadFirstPage = PublishSubject<Void>()
    let loadList = PublishSubject<[PostEntity]>()
    //페이지 로딩(파라메터로)
    let loadPostUsingParameter = PublishSubject<LoadParameter>()
    
    init(){
        bind()
    }
    
    private func bind(){
        //첫페이지
        loadFirstPage.subscribe{ [weak self] _ in
            self?.getPosts(page: 1)
        }.disposed(by: bag)
        
        //그다음
        loadMorePost.subscribe{ [weak self] _ in
            guard let self else {return}
            self.getPosts(page: self.currentPage)
        }.disposed(by: bag)
        
        //파라메터로 로드
        loadPostUsingParameter.subscribe(onNext:{ [weak self] params in
            guard let self else {return}
            log.debug("\(params)")
            self.getPosts(category: params.category, keyword: params.keyword, page: params.pageNum)
            self.currentPage = params.pageNum
        }).disposed(by: bag)
        
        loadList.subscribe(onNext:{ loadedList in
            self.currentPage+=1
            let oldList = self.postList.value
            print("oldList = \(oldList)")
            print("loadedList = \(loadedList)")
            self.postList.accept(oldList+loadedList)
        }).disposed(by: bag)
        
        
    }
    
    private func getPosts(category:Category? = nil,keyword:String? = nil ,page:Int )  {
        let endPoint = PostEndPoint.getPosts(category:category, keyword: keyword, page:page)
        
        let postNetwork = NetworkProvider()
        postNetwork.request(with: endPoint)
            .subscribe(onSuccess: { result in
                switch result{
                case .success(let list):
                    self.loadList.onNext(list.result)
                case .failure(let error):
                    print(error.localizedDescription)
                    self.loadList.onNext([])
                }
            }).disposed(by:  bag)
        
        
    }
}

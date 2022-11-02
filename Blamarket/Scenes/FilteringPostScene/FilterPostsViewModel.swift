//
//  FilterPostsViewModel.swift
//  Blamarket
//
//  Created by yangjs on 2022/11/01.
//

import Foundation
import RxSwift
import RxCocoa
enum SelectedType{
    case keyword
    case category
}
class FilterPostsviewModel{
    let bag = DisposeBag()
    
    let selectedCategoary : Observable<Category>
    let selectedKeyword : Observable<String>
    
    let postList = BehaviorRelay<[PostEntity]>(value: [])
    let loadMorePost = PublishSubject<Void>()
    let loadFirstPage = PublishSubject<Void>()
    let loadList = PublishSubject<[PostEntity]>()
    let loadPostUsingParameter = PublishSubject<LoadParameter>()
    
    let category : Category?
    let keyword : String?
    var currentPage = 1
    init(category: Category? , keyword:String? , selectedType:SelectedType){
        selectedCategoary = Observable.just(category).compactMap{$0}.share()
        selectedKeyword = Observable.just(keyword).compactMap{$0}.share()
        self.category = category
        self.keyword = keyword
        //첫페이지
        loadFirstPage.subscribe{ [weak self] _ in
            self?.getPosts(category: category,keyword: keyword,page: 1)
        }.disposed(by: bag)
        
        //그다음
        loadMorePost.subscribe{ [weak self] _ in
            guard let self else {return}
            self.getPosts(category: category,keyword: keyword,page: self.currentPage)
        }.disposed(by: bag)
        
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

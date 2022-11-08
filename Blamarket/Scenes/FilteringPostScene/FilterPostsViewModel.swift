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
    /**
     현대자동차그룹의 트럭 디자이너로 일하는 당신은 신차의 크기를 결정하려고 한다.
     총 N명의 소비자에게 신차 구매의사를 조사했다.
     i (1≤i≤N)번째 소비자는 Ai 개의 제안을 보냈는데, 이 중 j (1≤j≤Ai)번째 제안은 “신차의 크기가 Si,j 이상이라면 차량 한 대를 Pi,j원에 구매할 용의가 있다”는 것이다.
     하지만 소비자 각각에 맞춘 차량을 생산하기에는 설비를 위한 비용이 막대해질 것이므로, 신차의 크기를 하나로 결정해야한다.
     각 소비자는 트럭을 2대 이상 구매하지는 않을 것이다. 따라서, 당신은 각 소비자마다 그 소비자가 제시한 제안 중 하나를 수락하거나, 그 소비자의 제안을 모두 거절할 것이다. 이 때 당신이 정한 신차의 크기가 소비자의 여러가지 제안을 만족할 수 있다.
     당신은 매출에 따라 신차의 크기를 얼마로 설정해야 하는지를 알아보고자, M가지의 시나리오를 고려해 보기로 하였다. 당신은 모든 k (1≤k≤M)에 대해, 총 Qk원의 매출을 내려면, 신차의 크기가 최소 얼마여야 하는지를 구해야 한다.
     */
    
    
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
    /*
     Ai Si,1 Pi,1 … Si,Ai Pi,Ai*/
    /**
     4
     1 1 1
     1 2 2
     1 3 3
     1 4 4
     10
     1 2 3 4 5 6 7 8 9 10
     */
    
    /*
     5
     2 10 17 5 19
     2 8 7 10 21
     3 3 3 9 13 11 14
     3 5 3 1 2 9 15
     1 9 11
     11
     21 31 35 54 79 80 100 3 5 7 9
     */
}

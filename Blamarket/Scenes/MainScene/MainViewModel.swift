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
    let postDetailVM = PostDetailViewModel()
    let bag = DisposeBag()
    //테이블뷰 페이징 관련
    var postList = BehaviorRelay<[PostEntity]>(value: [])
    let loadMorePost = PublishSubject<Void>()
    let loadFirstPage = PublishSubject<Void>()
    let loadList = PublishSubject<[PostEntity]>()
    //페이지 로딩(파라메터로)
    let loadPostUsingParameter = PublishSubject<LoadParameter>()
    
    //모델 선텍
    let postModelSelected = PublishSubject<PostEntity>()
    
    init(){
        bind()
    }
    
    private func bind(){
        //첫페이지
        loadFirstPage.subscribe{ [weak self] _ in
            self?.postList.accept([])
            self?.currentPage = 1
            self?.getPosts(page: 1)
        }.disposed(by: bag)
        
        //그다음
        loadMorePost.subscribe{ [weak self] _ in
            guard let self else {return}
            self.getPosts(page: self.currentPage)
        }.disposed(by: bag)
        
    
        
        loadList.subscribe(onNext:{ loadedList in
            self.currentPage+=1
            let oldList = self.postList.value
            print("oldList = \(oldList.map{$0.title})")
            print("page=\(self.currentPage) loadedList = \(loadedList.map{$0.title})")
            self.postList.accept(oldList+loadedList)
        }).disposed(by: bag)
        
        postModelSelected.map { model -> PostDetailParameter in
            PostDetailParameter(
                email: UserDefaults.standard.string(forKey: UserConst.loginedID) ?? "didwns7347@naver.com",
                itemId: model.id)
        }.bind(to: postDetailVM.postDetailParams).disposed(by: bag)
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

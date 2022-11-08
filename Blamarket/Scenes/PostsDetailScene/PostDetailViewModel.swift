//
//  PostDetailViewModel.swift
//  Blamarket
//
//  Created by yangjs on 2022/11/01.
//

import Foundation
import RxCocoa
import RxSwift

class PostDetailViewModel{
    var postDetailEntity = PublishSubject<PostDetailEntity>()
    let postDetailParams = PublishSubject<PostDetailParameter>()
    
    let testModel = Observable<PostDetailEntity>.just(PostDetailEntity(id: 1,
                                                                       title: "이게 당근당근당근 내당근",
                                                                       images: ["https://images.punkapi.com/v2/227.png",
                                                                                "https://images.punkapi.com/v2/229.png",
                                                                                "https://images.punkapi.com/v2/keg.png"
                                                                               ],
                                                                       price: "10000",
                                                                       date: "2022-11-07",
                                                                       email: "didwns7347",
                                                                       viewCount: 100,
                                                                       category: "1",
                                                                       wish: true,
                                                                      content: "hello my name is Joon Soo im very happy "))
    
    let bag = DisposeBag()
    init(){
        postDetailParams.subscribe(onNext:{self.getPostDetail(param: $0)}).disposed(by: bag)
    }
    
    func getPostDetail(param:PostDetailParameter){
        let endPoint = PostEndPoint.postDetail(param: param)
        let postNetwork = NetworkProvider()
        postNetwork.request(with: endPoint)
            .subscribe(onSuccess:{ result in
                switch result{
                case .success(let data):
                    if data.status == 200{
                        let model = data.result
                        self.postDetailEntity.onNext(model)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }).disposed(by: bag)
    }
}

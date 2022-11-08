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

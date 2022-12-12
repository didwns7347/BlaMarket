//
//  UserInfoViewModel.swift
//  Blamarket
//
//  Created by yangjs on 2022/10/19.
//

import RxSwift
import RxCocoa

struct UserInfoViewModel{
    let cellData : Driver<[String]>
    init(){
        let datas = [
            "💚 목록 보기",
            "등록한 게시글 보기",
            "구매요청 게시글 보기"
        ]
        self.cellData = Driver.just(datas)
    }
}

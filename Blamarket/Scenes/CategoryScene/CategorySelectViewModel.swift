//
//  CategorySelectViewModel.swift
//  Blamarket
//
//  Created by yangjs on 2022/10/21.
//

import Foundation
import RxSwift
import RxCocoa
//photo3idea_studio
//amonrat rungreangfangsai
//Freepik
struct CategorySelectViewModel{
    let categoryObservalbe = Driver<[Category]>.of([
        Category(id: 1, name: "디지털/가전", iconURL: "digital.png"),
        Category(id: 2, name: "게임", iconURL: "game.png"),
        Category(id: 3, name: "스포츠/레저", iconURL: "health.png"),
        Category(id: 4, name: "유아/아동용품", iconURL: "child.png"),
        Category(id: 5, name: "여성패션/잡화", iconURL: "womanClothing.png"),
        Category(id: 6, name: "뷰티/미용", iconURL: "beauty.png"),
        Category(id: 7, name: "남성패션/잡화", iconURL: "manClothing.png"),
        Category(id: 8, name: "생활/식품", iconURL: "life.png"),
        Category(id: 9, name: "가구",iconURL: "home.png"),
        Category(id: 10, name: "도서/티켓/취미", iconURL: "books.png"),
        Category(id: 11, name: "기타", iconURL: "etc.png")]
    )
}

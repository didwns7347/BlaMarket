//
//  RegistItemViewModel.swift
//  Blamarket
//
//  Created by yangjs on 2022/09/19.
//

import UIKit
import RxCocoa
import RxSwift
import PhotosUI
struct RegistItemViewModel{
    //let defaultImageList = [UIImage(systemName: "camera")!]
    let titleTextFieldCellViewModel = TitleTextFieldCellViewModel()
    let priceTextFieldCellViewModel = PriceTextFieldCellViewModel()
    let categoryViewModel = CategoryViewModel()
    let detailWriteFormCellViewModel = DetailWriteFormCellViewModel()
    
    var imageListSubject =  BehaviorSubject<[NSItemProvider?]>(value:[nil])
    var imageListDrive : Driver<[NSItemProvider?]>
    //viewmodel -> view
    let cellData : Driver<[String]>
    let presentAlert: Signal<Alert>
    let push : Driver<CategoryViewModel>
    //view -> viewmodel
    let itemSelected = PublishRelay<Int>()
    let submitButtonTapped = PublishRelay<Void>()
    
    let model = RegisterItemModel()
    init(){
        let title = Observable.just("글 제목")
        let categoryViewModel = CategoryViewModel()
        let category = categoryViewModel
            .selectedCategory
            .map{$0.name}
            .startWith("카테고리 선텍")
        let price = Observable.just("가격 (선택사항)")
        let detail = Observable.just("내용을 기입 하세요")
        
        self.cellData = Observable
            .combineLatest(title,category,price,detail){
                [$0,$1,$2,$3]
            }.asDriver(onErrorDriveWith:.empty())
        let titleMSG = titleTextFieldCellViewModel
            .titleText
            .map{$0?.isEmpty ?? true}
            .startWith(true)
            .map{ $0 ? ["- 글 제목을 입력해 주세요"]:[]}
        
        let categoryMSG = categoryViewModel
            .selectedCategory
            .map{ _ in false}
            .startWith(true)
            .map{$0 ? ["- 카테고리를 선택해 주세요"] : []}
        
        let detailMsg  = detailWriteFormCellViewModel
            .contentValue
            .map{$0?.isEmpty ?? true}
            .startWith(true)
            .map{$0 ? ["- 내용을 입력해주세요"]:[]}
        let errorMsg = Observable
            .combineLatest(titleMSG,
                           categoryMSG,
                           detailMsg
            ){$0 + $1 + $2}
        
        self.presentAlert = submitButtonTapped
            .withLatestFrom(errorMsg){ $1 }
            .map(model.setAlert)
            .asSignal(onErrorSignalWith: .empty())
        
        self.push = itemSelected
            .compactMap{row -> CategoryViewModel? in
                guard case 1 = row else{
                    return nil
                }
                return categoryViewModel
            }
            .asDriver(onErrorDriveWith: .empty())
        imageListDrive = imageListSubject.asDriver(onErrorJustReturn: [nil])
        
        
    }
    
}

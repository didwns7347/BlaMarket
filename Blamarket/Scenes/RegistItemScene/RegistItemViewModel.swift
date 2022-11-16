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
final class RegistItemViewModel{
    let bag = DisposeBag()
    let model = RegisterItemModel()
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
    
    //서버전송
    let selectedImages = BehaviorSubject<[NSItemProvider]>(value: [])
    let imageLoadedCompleted = PublishSubject<[UIImage]>()
    
    let uploadSuccess = PublishSubject<Void>()
    let uploadFailed = PublishSubject<String>()
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
            .map{$0.isEmpty}
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
            .filter{$0.isEmpty == false}
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
         
        let inputs = Observable.combineLatest(
            selectedImages,titleTextFieldCellViewModel.titleText, categoryViewModel.selectedCategory,
            priceTextFieldCellViewModel.priceValue, detailWriteFormCellViewModel.contentValue).share()
        
        
        let postDatas = submitButtonTapped.withLatestFrom(inputs)
            .map{ [weak self] info -> PostModel in
                //guard let self = self else{return}
                //title: String, category: Category, contents: String?, imageProviders: [NSItemProvider], price: String?, companyId:String)
                let postModel = PostModel(title: info.1 ,
                                          category: info.2,
                                          contents: info.4,
                                          imageProviders: info.0,
                                          price: info.3,
                                        companyId: "1")
                guard let self = self else { return postModel}
                postModel.loadedImagesSubject.bind(to: self.imageLoadedCompleted).disposed(by: self.bag)
                return postModel
            }.share()
        
        let  submitData = submitButtonTapped.withLatestFrom(Observable.combineLatest(postDatas,errorMsg))
            .filter{$0.1.isEmpty}
            .map{$0.0}.share()
#if DEBUG
        submitButtonTapped.subscribe { _ in
            print("tapped")
        }.disposed(by: bag)
        
        postDatas.subscribe(onNext: {data in
            print(data)
        }).disposed(by: bag)
        
        Observable.combineLatest(postDatas,errorMsg)
            .subscribe(onNext:{print($0,$1)}).disposed(by: bag)
        submitData.subscribe(onNext:{print("submitData = ",$0.providers.count)}).disposed(by: bag)
        
        selectedImages.subscribe(onNext:{
            print($0.count)
        }).disposed(by: bag)
        
        imageLoadedCompleted.subscribe(onNext:{img in
            print(img.count)
        }).disposed(by: bag)
        
        submitData.subscribe(onNext:{ model in
            print("이게 머야 ^^ㅣ발아")
            
        }).disposed(by: bag)
#endif
        //
        let postItemResult = Observable.combineLatest(submitData,imageLoadedCompleted)
            .flatMap{ (postModel,images)  in
                let endpoint = PostEndPoint.post(postModel: postModel , images: images)
                let provider = NetworkProvider()
                let result =  provider.multipartRequest(with: endpoint)
                return result
            }.share()
    
        postItemResult.subscribe(onNext:{ result in
            switch result{
            case .failure(let error):
                print(error)
                self.uploadFailed.onNext(error.localizedDescription)
            case .success(let data):
                print(data)
                self.uploadSuccess.onNext(())
            }
        }).disposed(by: bag)
    }
    
}

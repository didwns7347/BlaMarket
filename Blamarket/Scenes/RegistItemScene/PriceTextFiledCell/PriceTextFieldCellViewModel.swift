//
//  PriceTextFieldCellViewModel.swift
//  UsedGoodsUpload
//
//  Created by yangjs on 2022/07/28.
//

import RxSwift
import RxCocoa

struct PriceTextFieldCellViewModel{
    let showFreeShareButton : Signal<Bool>
    let resetPrice : Signal<Void>
    
    //view -> viewModel
    let priceValue = PublishRelay<String?>()
    let freeShareButtonTapped = PublishRelay<Void>()
    
    init(){
        self.showFreeShareButton = Observable
            .merge(
                priceValue.map{$0 ?? "" == "0"},
                freeShareButtonTapped.map{ _ in false}
            )
            .asSignal(onErrorJustReturn: false)
        
        self.resetPrice = freeShareButtonTapped
            .asSignal(onErrorSignalWith: .empty())
    }
}

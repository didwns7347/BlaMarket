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
    var imageListSubject =  BehaviorSubject<[NSItemProvider?]>(value:[nil])
    var imageListDrive : Driver<[NSItemProvider?]>
    
    init(){
        imageListDrive = imageListSubject.asDriver(onErrorJustReturn: [nil])
        
    }
    
}

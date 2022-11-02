//
//  PostDetailViewController.swift
//  Blamarket
//
//  Created by yangjs on 2022/11/01.
//

import SnapKit
import UIKit
import RxCocoa
import RxSwift

class PostDetailViewController : UIViewController{

    
    let photoSliderView = PhotoSliderView()
    
    let pageView : UIPageControl = UIPageControl()
    
    let bag = DisposeBag()
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
      
    }
    
    func bind(vm:PostDetailViewModel){
        #if DEBUG
        let testData = Observable<[UIImage]>.just([UIImage(systemName: "ruler")!,
                                                   UIImage(systemName: "medal")!,
                                                   UIImage(systemName: "link")!])
        #endif
        testData.subscribe(onNext:{self.photoSliderView.configure(with: $0)}).disposed(by: bag)
    }
    
    
}


private extension PostDetailViewController{
    func attribute(){

        
    }
    
    func layout(){
        [photoSliderView].forEach{view.addSubview($0)}
        photoSliderView.snp.makeConstraints{
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(300)
        }
    }
}

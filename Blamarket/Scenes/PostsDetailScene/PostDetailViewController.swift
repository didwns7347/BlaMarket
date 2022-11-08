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
    
    let scrollview : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .systemGray
        return scrollView
    }()
    let photoSliderView = PhotoSliderView()
    let postHeaderView = PostHeaderView()
    
    let pageView : UIPageControl = UIPageControl()
    
    let contentTextView : UITextView = {
        let text = UITextView()
        return text
    }()
    
    let startBtn : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "star"), for: .normal)
        return button
    }()
    
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
        testData.subscribe(onNext:{self.photoSliderView.configure(with: $0)}).disposed(by: bag)
#endif
        let postModel = vm.postDetailEntity.share()
        //제목 설정
        postModel.map{$0.title}.bind(to: self.rx.title).disposed(by: bag)
        
    }
    
    
}


private extension PostDetailViewController{
    func attribute(){
        self.title = "상세 보기"
        
    }
    
    func layout(){
        [scrollview].forEach{
            view.addSubview($0)
        }
        
        scrollview.snp.makeConstraints{$0.edges.equalTo(view.safeAreaLayoutGuide)}
        
        [photoSliderView,contentTextView,postHeaderView].forEach{scrollview.addSubview($0)}
        
        photoSliderView.snp.makeConstraints{
            $0.top.left.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(300)
        }
        
        postHeaderView.snp.makeConstraints{
            $0.top.equalTo(photoSliderView.snp.bottom).offset(20)
            $0.width.equalToSuperview()
            $0.height.equalTo(90)
        }
        
        contentTextView.snp.makeConstraints{
            $0.top.equalTo(postHeaderView.snp.bottom).offset(20)
            $0.left.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(2000)
        }
    }
}

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
        scrollView.backgroundColor = .systemBackground
        return scrollView
    }()
    let photoSliderView = PhotoSliderView()
    let postHeaderView = PostHeaderView()
    let commentsView = UIView()
    
    let pageView : UIPageControl = UIPageControl()
    
    let contentTextView : UITextView = {
        let text = UITextView()
        text.font = .boldSystemFont(ofSize: 20)
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
        //testData.subscribe(onNext:{self.photoSliderView.configure(with: $0)}).disposed(by: bag)
        vm.postDetailEntity
            .asDriver(onErrorJustReturn: PostDetailEntity(id: -1,
                                                          email: "unknown",
                                                          title: "Notitle",
                                                          content: "NO",
                                                          price: 0,
                                                          date: "0000-00-00",
                                                          viewCount: nil,
                                                          category: "0",
                                                          images: []))
            .drive(onNext:{ model in
                if model.id == -1{
                    self.rx.completeAlert.onNext( Alert(title:"실패" , message:"잠시후 다시 시도해 주세요." ))
                    return
                }
                self.postHeaderView.configView(postModel: model)
                self.photoSliderView.configView(postModel: model)
                self.contentTextView.text = model.content
            }).disposed(by: bag)
        
#endif
        let postModel = vm.postDetailEntity.share()
//        self.postHeaderView.starButton
    }
    
    
}


private extension PostDetailViewController{
    func attribute(){
        self.title = "상세 보기"
        self.commentsView.backgroundColor = .systemBackground
    }
    
    func layout(){
        [scrollview].forEach{
            view.addSubview($0)
        }
        
        scrollview.snp.makeConstraints{$0.edges.equalTo(view.safeAreaLayoutGuide)}
        
        [photoSliderView,contentTextView,postHeaderView,commentsView].forEach{scrollview.addSubview($0)}
        
        photoSliderView.snp.makeConstraints{
            $0.top.left.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(300)
        }
        
        postHeaderView.snp.makeConstraints{
            $0.top.equalTo(photoSliderView.snp.bottom)
            $0.width.equalToSuperview()
            $0.height.equalTo(90)
        }
        
        contentTextView.snp.makeConstraints{
            $0.top.equalTo(postHeaderView.snp.bottom).offset(20)
            $0.left.equalToSuperview().inset(10)
            $0.width.equalToSuperview().inset(10)
            $0.height.equalTo(500)
        }
        commentsView.snp.makeConstraints{
            $0.top.equalTo(contentTextView.snp.bottom)
            $0.left.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(2000)
        }
        
        
    }
}

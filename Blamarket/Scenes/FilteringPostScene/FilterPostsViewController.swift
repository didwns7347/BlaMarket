//
//  FilterPostsViewController.swift
//  Blamarket
//
//  Created by yangjs on 2022/11/01.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class FilterPostsViewController : UIViewController{
    let tableview = UITableView()
    let bag = DisposeBag()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        attribute()
        layout()
  
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(vm:FilterPostsviewModel){
        vm.selectedKeyword.bind(to: self.rx.title).disposed(by: bag)
        vm.selectedCategoary.map{$0.name}.bind(to: self.rx.title).disposed(by: bag)
        vm.loadFirstPage.onNext(())
        
        vm.postList.bind(to: self.tableview.rx.items(cellIdentifier: "mainCell",cellType: MainTableViewCell.self)){ (row, model, cell) in
            cell.configCell(model: model,row: row)
        }.disposed(by: bag)
        
        self.tableview.rx.itemSelected.subscribe(onNext:{
            self.tableview.deselectRow(at: $0, animated: true)
        }).disposed(by: bag)
        
        tableview.rx.didScroll.subscribe { [weak self] _ in
                    guard let self = self else { return }
                    let offSetY = self.tableview.contentOffset.y
                    let contentHeight = self.tableview.contentSize.height

                    if offSetY > (contentHeight - self.tableview.frame.size.height - 100) {
                        vm.loadMorePost.onNext(())
                    }
                }
                .disposed(by: bag)
        
    }
    
}
private extension FilterPostsViewController{
    func attribute(){
        view.backgroundColor = .systemBackground
        

        
        let nibName = UINib(nibName: "MainTableViewCell", bundle: nil)
        self.tableview.register(nibName, forCellReuseIdentifier: "mainCell")
    }
    
    func layout(){
        [tableview].forEach { content in
            view.addSubview(content)
        }
        
        tableview.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
        
}

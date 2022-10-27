//
//  SearchPostsViewController.swift
//  Blamarket
//
//  Created by yangjs on 2022/10/21.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift
class SearchPostsViewController: UIViewController{
    let bag = DisposeBag()
    let deleteRecode = PublishSubject<SearchRecode>()
    let reloadData = PublishSubject<Void>()
    var tableview : UITableView = {
        let tableview = UITableView()
 
        return tableview
        
    }()
    
    let searchBar : UISearchBar = {
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 330, height: 0))
        searchBar.placeholder = "Search User"
    
        return searchBar
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func bind(vm:SearchPostsViewModel){
        vm.requestLoadData.onNext(())
        
        vm.searchRecodes
            .bind(to: tableview.rx.items(cellIdentifier: "searchCell", cellType: SearchTableViewCell.self)){ row,searchRecode,cell in
                cell.configCell(model: searchRecode)
                cell.didDelete = {[weak self] in
                    self?.deleteRecode.onNext(searchRecode)
                    self?.reloadData.onNext(())
                }
            }.disposed(by: bag)
        
        self.deleteRecode
            .bind(to: vm.recodeDeleteRequset)
            .disposed(by: bag)
        
        self.reloadData.bind(to: vm.requestLoadData).disposed(by: bag)
        
        let keywordSelected = self.searchBar.rx.searchButtonClicked.withLatestFrom(self.searchBar.rx.text)
        
        keywordSelected.subscribe(onNext:{
            print($0)
        }).disposed(by: bag)
        
    }
    
    
    
}
private extension SearchPostsViewController{
    func attribute(){
        self.view.backgroundColor = .systemBackground
        self.navigationItem.backBarButtonItem?.title = "<"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: searchBar)
        let nibName = UINib(nibName: "SearchTableViewCell", bundle: nil)
        tableview.register(nibName, forCellReuseIdentifier: "searchCell")
        [tableview].forEach{view.addSubview($0)}
    }
    
    func layout(){
        self.tableview.rowHeight = 40
        tableview.snp.makeConstraints{$0.edges.equalTo(view.safeAreaLayoutGuide)}
    }
}

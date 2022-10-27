//
//  MainViewController.swift
//  Blamarket
//
//  Created by yangjs on 2022/08/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class MainViewController : UIViewController{
    let bag = DisposeBag()
    let categorySelected = PublishSubject<Category>()
    //test observable
    let observable = Observable.of([PostEntity(id: 1, title: "test", content: "testContent", thumbnail: "https://images.punkapi.com/v2/2.png", price: 100000, createDate: "2022-10-17", usedDate: "3개월", viewCount: "111")])
    
    let tableview = UITableView()
    var searchVC : SearchPostsViewController?
    var categorySelectVC : CategorySelectViewController?
    
    lazy var createButton : UIBarButtonItem  = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        return UIBarButtonItem(customView: button)
    }()
    
    lazy var selectCategoryButton : UIBarButtonItem  = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "list.dash"), for: .normal)
        button.addTarget(self, action: #selector(selectCategoryButtonTapped), for: .touchUpInside)
        return UIBarButtonItem(customView: button)
    }()
    
    lazy var searchButton : UIBarButtonItem = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        button.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        return UIBarButtonItem(customView: button)
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        attribute()
        layout()
  
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(vm: MainViewModel){
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
        
        self.categorySelected
            .map{catetory in
                return LoadParameter(pageNum: 0, category: catetory, keyword: nil)
            }
            .bind(to: vm.loadPostUsingParameter)
            .disposed(by: bag)
        
      
    }
    
    
    
    
}
private extension MainViewController{
    @objc func selectCategoryButtonTapped(){
        self.categorySelectVC = CategorySelectViewController()
        let vm = CategorySelectViewModel()
        categorySelectVC?.bind(vm: vm)
        vm.catetorySubject.bind(to: self.categorySelected).disposed(by: bag)
        self.show(categorySelectVC!, sender: self)
    }
    
    
    @objc func searchButtonTapped(){
        self.searchVC = SearchPostsViewController()
        let vm = SearchPostsViewModel()
        searchVC?.bind(vm: vm)
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = backBarButtonItem
//        출처: https://zeddios.tistory.com/29 [ZeddiOS:티스토리]
        self.show(searchVC!, sender: self)
    }
    
    @objc func createButtonTapped(){
        let vc = RegistItemViewController()
        let vm = RegistItemViewModel()
        vc.bind(viewModel: vm)
        self.show(vc, sender: self)
    }
    
    func attribute(){
        view.backgroundColor = .systemBackground
        self.title = UserDefaults.standard.string(forKey: UserConst.Company) ?? "게시판"
        self.navigationItem.hidesBackButton = true
        self.navigationItem.rightBarButtonItems = [self.createButton,self.searchButton,self.selectCategoryButton]

        
        let nibName = UINib(nibName: "MainTableViewCell", bundle: nil)
        self.tableview.register(nibName, forCellReuseIdentifier: "mainCell")

        
    }
    
//    private func getCreateButton()->UIBarButtonItem
    func layout(){
        self.tableview.rowHeight = 100
        
        [tableview].forEach{
            view.addSubview($0)
        }
        
        tableview.snp.makeConstraints{
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
  

}

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

    
    let tableview = UITableView()

    
    lazy var createButton : UIBarButtonItem  = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus")?.imageResized(to: CGSizeMake(26, 22)), for: .normal)
        button.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        return UIBarButtonItem(customView: button)
    }()
    
    lazy var selectCategoryButton : UIBarButtonItem  = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "list.dash")?.imageResized(to: CGSizeMake(26, 22)), for: .normal)
        button.addTarget(self, action: #selector(selectCategoryButtonTapped), for: .touchUpInside)
        return UIBarButtonItem(customView: button)
    }()
    
    lazy var searchButton : UIBarButtonItem = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "magnifyingglass")?.imageResized(to: CGSizeMake(26, 22)), for: .normal)
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
        self.rx.viewWillAppear
            .map{ _ in
                ()
            }
            .bind(to: vm.loadFirstPage)
            .disposed(by: bag)
        
        //vm.loadFirstPage.onNext(())
        
        
        vm.postList.bind(to: self.tableview.rx.items(cellIdentifier: "mainCell",cellType: MainTableViewCell.self)){ (row, model, cell) in
            print(model)
            cell.configCell(model: model,row: row)
        }.disposed(by: bag)
        
        self.tableview.rx.itemSelected.subscribe(onNext:{
            self.tableview.deselectRow(at: $0, animated: true)
        }).disposed(by: bag)
        
        
        //테이블뷰 아이템 실렉트
        tableview.rx.modelSelected(PostEntity.self).subscribe(onNext:{ item in
            
            let vc = PostDetailViewController()
            vm.postModelSelected.onNext(item)
            vc.bind(vm: vm.postDetailVM)
            self.show(vc, sender: self)
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
private extension MainViewController{
    @objc func selectCategoryButtonTapped(){
        let categorySelectVC = CategorySelectViewController()
        let vm = CategorySelectViewModel()
        categorySelectVC.bind(vm: vm)
    
        self.show(categorySelectVC, sender: self)
    }
    
    
    @objc func searchButtonTapped(){
        let searchVC = SearchPostsViewController()
        let vm = SearchPostsViewModel()
        searchVC.bind(vm: vm)
        
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = backBarButtonItem
//        출처: https://zeddios.tistory.com/29 [ZeddiOS:티스토리]
        self.show(searchVC, sender: self)
    }
    
    @objc func createButtonTapped(){
        let vc = RegistItemViewController()
        let vm = RegistItemViewModel()
        vc.bind(viewModel: vm)
        self.show(vc, sender: self)
    }
    
    func attribute(){
        view.backgroundColor = .systemBackground
        let attrs = [
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont(name: "Georgia-Bold", size: 26)!
        ]

        UINavigationBar.appearance().titleTextAttributes = attrs
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

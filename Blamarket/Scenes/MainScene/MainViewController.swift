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
    //test observable
    let observable = Observable.of([PostEntity(id: 1, title: "test", content: "testContent", thumbnail: "https://images.punkapi.com/v2/2.png", price: "10000원", createDate: "2022-10-17", usedDate: "3개월", viewCount: "111")])
    
    let tableview = UITableView()

    lazy var createButton : UIBarButtonItem  = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
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
        observable.bind(to: self.tableview.rx.items(cellIdentifier: "mainCell",cellType: MainTableViewCell.self)){ (row, model, cell) in
            cell.configCell(model: model,row: row)
        }.disposed(by: bag)
        
        self.tableview.rx.itemSelected.subscribe(onNext:{
            self.tableview.deselectRow(at: $0, animated: true)
        }).disposed(by: bag)
    }
    
    
}
private extension MainViewController{
    func attribute(){
        view.backgroundColor = .systemBackground
        self.title = UserDefaults.standard.string(forKey: UserConst.Company) ?? "게시판"
        self.navigationItem.hidesBackButton = true
        self.navigationItem.rightBarButtonItem = self.createButton

        
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

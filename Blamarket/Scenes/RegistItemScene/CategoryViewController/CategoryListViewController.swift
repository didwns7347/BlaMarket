//
//  CategoryListViewController.swift
//  UsedGoodsUpload
//
//  Created by yangjs on 2022/07/28.
//

import UIKit
import RxSwift
import RxCocoa


class CategoryListViewController : UIViewController{
    let disposeBag = DisposeBag()
    let tableView = UITableView()
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        attribute()
        layout()
    }
    func bind(_ viewModel : CategoryViewModel){
        viewModel.cellData
            .drive(tableView.rx.items){ tv,row,data in
                let cell = tv.dequeueReusableCell(withIdentifier:"categoryListCell",
                                                  for: IndexPath(row:row, section: 0))
                cell.textLabel?.text = data.name
                return cell
            }.disposed(by: disposeBag)
        viewModel.pop
            .emit(onNext:{ [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }).disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .map{$0.row}
            .bind(to:viewModel.itemSelected)
            .disposed(by: disposeBag)
    }
    private func attribute(){
        view.backgroundColor = .systemBackground
        
        tableView.backgroundColor = .systemBackground
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "categoryListCell")
        tableView.separatorStyle = .singleLine
        tableView.tableFooterView = UIView()
        
    }
    private func layout(){
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

}

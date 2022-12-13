//
//  UserInfoViewController.swift
//  Blamarket
//
//  Created by yangjs on 2022/10/19.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
enum SelectCase : Int{
    case heartList
    case postList
    case buyList
}
class UserInfoViewConroller : UIViewController{
    let bag = DisposeBag()
    
    let tvLabel : UILabel = {
        let label = UILabel()
        label.text = "내 활동"
        label.tintColor = .secondaryLabel
        label.font = .systemFont(ofSize: 28, weight: .bold)
        return label
    }()
    
    let tableView : UITableView = {
        let tableView = UITableView()
        tableView.tableHeaderView = UILabel()
        return tableView
    }()
    
    
    let userProfileView : UserProfileView = {
        let view = UserProfileView()
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.secondaryLabel.cgColor
        view.layer.cornerRadius = 10
        return view
    }()
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        layout()
        attribute()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func bind(vm: UserInfoViewModel ){
        vm.cellData
            .drive(tableView.rx.items){ tv,row,data in
                let cell = tv.dequeueReusableCell(withIdentifier:"myinfocell",
                                                  for: IndexPath(row:row, section: 0))
                cell.textLabel?.text = data
                cell.textLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
                return cell
            }.disposed(by: bag)
        
        tableView.rx.itemSelected.subscribe( onNext:{ indexPath in
            guard let selectType = SelectCase(rawValue: indexPath.row) else{
                return
            }
            switch selectType{
            case .heartList:
                break
                
            case .buyList:
                break
                
            case .postList:
                break

            }
        }).disposed(by: bag)
        
        userProfileView.editProfile.rx.tap.subscribe(onNext:{
            let vm = ProfileEditVM()
            let vc = ProfileEditVC()
            vc.bind(vm: vm)
            
            self.show(vc, sender: self)
        }).disposed(by: bag)
    }
}
private extension UserInfoViewConroller{
    func attribute(){
        self.view.backgroundColor = .systemBackground
        self.title = "내 정보"
        tableView.backgroundColor = .systemBackground
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "myinfocell")
        tableView.separatorStyle = .singleLine
    }
    
    func layout(){
        [userProfileView,tvLabel,tableView].forEach { sub in
            view.addSubview(sub)
        }
        
        userProfileView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.equalTo(150)
        }
        
        tvLabel.snp.makeConstraints { make in
            make.top.equalTo(userProfileView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(15)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(tvLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(10)
            make.bottom.equalToSuperview()
        }
    }
}

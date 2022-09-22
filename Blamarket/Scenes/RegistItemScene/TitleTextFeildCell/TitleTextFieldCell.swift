//
//  TitleTextFieldCell.swift
//  UsedGoodsUpload
//
//  Created by yangjs on 2022/07/28.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift
          
class TitleTextFieldCell : UITableViewCell{
    let disposeBag = DisposeBag()
    
    let titleInputField = UITextField()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(vm : TitleTextFieldCellViewModel){
        titleInputField.rx.text
            .bind(to:vm.titleText)
            .disposed(by: disposeBag)
    }
    
    private func attribute(){
        titleInputField.font = .systemFont(ofSize: 17)
    }
    
    private func layout(){
        contentView.addSubview(titleInputField)
        titleInputField.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20)
        }
    }
    
}



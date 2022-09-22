//
//  DetailWriteFromCell.swift
//  UsedGoodsUpload
//
//  Created by yangjs on 2022/07/28.
//

import UIKit
import RxSwift
import RxCocoa

class DetailWriteFormCell : UITableViewCell{
    let disposeBag = DisposeBag()
    let contentInputView = UITextView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        attribute()
        layout()
    }
    func bind(_ viewModel : DetailWriteFormCellViewModel){
        contentInputView.rx.text
            .bind(to:viewModel.contentValue)
            .disposed(by: disposeBag)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func attribute(){
        contentInputView.font = .systemFont(ofSize: 17)
    }
    
    private func layout(){
        contentView.addSubview(contentInputView)
        
        contentInputView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(15)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(300)
        }
        
    }
}

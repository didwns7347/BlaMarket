//
//  PriceTextFieldCell.swift
//  UsedGoodsUpload
//
//  Created by yangjs on 2022/07/28.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift
 

class PriceTextFieldCell : UITableViewCell{
    let disposeBag = DisposeBag()
    let priceInputField = UITextField()
    let freeshareButton = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func bind(_ viewModel:PriceTextFieldCellViewModel){
        viewModel.showFreeShareButton
            .map{!$0}
            .emit(to: freeshareButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.resetPrice
            .map{ _ in ""}
            .emit(to: priceInputField.rx.text)
            .disposed(by: disposeBag)
        
        freeshareButton.rx.tap
            .bind(to: viewModel.freeShareButtonTapped)
            .disposed(by:disposeBag)
        
        priceInputField.rx.text
            .bind(to:viewModel.priceValue)
            .disposed(by: disposeBag)
    }
    
    
    private func attribute(){
        freeshareButton.setTitle("무료나눔", for: .normal)
        freeshareButton.setTitleColor(.orange, for: .normal)
        freeshareButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        freeshareButton.titleLabel?.font = .systemFont(ofSize: 18)
        freeshareButton.tintColor = .orange
        freeshareButton.layer.borderColor = UIColor.orange.cgColor
        freeshareButton.layer.borderWidth = 1.0
        freeshareButton.layer.cornerRadius = 10.0
        freeshareButton.clipsToBounds = true
        freeshareButton.semanticContentAttribute = .forceRightToLeft
        
        priceInputField.keyboardType = .numberPad
        priceInputField.font = .systemFont(ofSize: 17)
        
        
        
    }
    
    private func layout(){
        [priceInputField, freeshareButton].forEach {
            contentView.addSubview($0)
        }
        
        priceInputField.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20)
        }
        
        freeshareButton.snp.makeConstraints { make in
            make.top.bottom.leading.equalToSuperview().inset(15)
            make.width.equalTo(100)
        }
    }

}

//
//  UserProfileView.swift
//  Blamarket
//
//  Created by yangjs on 2022/12/12.
//

import UIKit
import SnapKit

class UserProfileView: UIView {
    
    let imageView : UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(systemName: "person.fill")
        imgView.tintColor = .secondaryLabel
        imgView.layer.borderWidth = 1
        imgView.layer.borderColor = UIColor.secondaryLabel.cgColor
        return imgView
    }()
    
    let nameLable : UILabel = {
        let label = UILabel()
        label.text = "닉네임"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    let emailLabel : UILabel = {
        let label = UILabel()
        label.text = "이메일 주소"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    let editProfile : UIButton = {
        let button = UIButton()
        button.setTitle("수정", for: .normal)
        button.backgroundColor = ColorConst.MAIN_COLOR
        button.layer.cornerRadius =  10
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    func setupView(){
        
        [imageView,emailLabel,nameLable,editProfile].forEach { sub in
            addSubview(sub)
        }
        
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.leading.equalToSuperview().inset(20)
            make.width.height.equalTo(75)
        }
        
        emailLabel.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(20)
            make.leading.equalTo(imageView.snp.trailing).offset(20)
        }
        
        nameLable.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(10)
            make.leading.trailing.equalTo(emailLabel)
        }
        
        editProfile.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(30)
            make.top.equalTo(imageView.snp.bottom).offset(20)
            make.height.equalTo(30)
        }
    }
}

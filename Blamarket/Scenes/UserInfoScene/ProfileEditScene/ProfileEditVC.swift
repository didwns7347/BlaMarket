//
//  ProfileEditVC.swift
//  Blamarket
//
//  Created by yangjs on 2022/12/13.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class ProfileEditVC : UIViewController{
    let bag = DisposeBag()
    let submitButton = UIBarButtonItem()
    let backButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: nil, action: nil)
    
    let profileImageView : UIImageView = {
        let view = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view.image = UIImage(systemName: "person.fill")
        view.layer.cornerRadius = view.frame.height/2
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.clear.cgColor
        view.tintColor = .secondaryLabel
        view.clipsToBounds = true
        return view
    }()
    
    let nameLabel : UILabel = {
        let label = UILabel()
        label.text = "닉네임"
        return label
    }()
    
    let nameTextFeild : UITextField = {
        let textfeild = UITextField()
        textfeild.borderStyle = .roundedRect
        textfeild.layer.cornerRadius = 10
        return textfeild
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        layout()
        attribute()
      
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(vm:ProfileEditVM){
        backButton.rx.tap
            .subscribe(onNext:{
                self.navigationController?.popViewController(animated: true)
                
            })
            .disposed(by: bag)
    }
    
}
private extension ProfileEditVC {
    func attribute(){
        view.backgroundColor = .systemBackground
        setImageCircle()
        
        submitButton.title = "제출"
        submitButton.style = .done
        submitButton.tintColor = .label
        backButton.tintColor = .label
        navigationItem.setRightBarButton(submitButton, animated: true)
        navigationItem.setLeftBarButton(backButton, animated: true)
        navigationItem.hidesBackButton = true
        
    }
    func layout(){
        [profileImageView,nameLabel,nameTextFeild].forEach { sv in
            view.addSubview(sv)
        }
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.height.width.equalTo(100)
            make.centerX.equalToSuperview()
        }
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(10)
        }
        nameTextFeild.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.leading.trailing.equalTo(nameLabel)
        }
    }
    
    func setImageCircle(){
       
    }
}

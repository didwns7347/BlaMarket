//
//  RegistViewController.swift
//  Blamarket
//
//  Created by yangjs on 2022/08/19.
//

import RxSwift
import UIKit
import RxCocoa
import SnapKit

class RegistViewController : UIViewController{
    let bag = DisposeBag()
    
    private lazy var emailLabel : UILabel = {
        let label = UILabel()
        label.text = "이메일"
        return label
    }()
    
    private lazy var pwInput : UITextField = {
        let textField = UITextField()
        textField.placeholder = "비밀번호를 입력해주세요"
        textField.borderStyle = .bezel
        textField.isSecureTextEntry = true
        return textField
    }()
    
    lazy var pwCheckInput : UITextField = {
        let textField = UITextField()
        textField.placeholder = "비밀번호 확인"
        textField.borderStyle = .bezel
        textField.isSecureTextEntry = true
        return textField
    }()
    
    lazy var nickNameInput : UITextField = {
        let textField = UITextField()
        textField.placeholder = "닉네임"
        textField.borderStyle = .bezel
        return textField
    }()
    
    lazy var submitButton : UIButton = {
        let button = UIButton()
        button.setTitle("가입하기", for: .normal)
        button.backgroundColor = ColorConst.MAIN_COLOR
        return button
    }()
    
 
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(vm:RegistViewModel){
        print(vm.self)
        vm.email
            .bind(to: self.emailLabel.rx.text)
            .disposed(by: bag)
        
        nickNameInput.rx.text.orEmpty
            .bind(to: vm.nicknameInput)
            .disposed(by: bag)
      
        pwInput.rx.text.orEmpty
            .bind(to: vm.pwInput)
            .disposed(by: bag)
        
        pwCheckInput.rx.text.orEmpty
            .bind(to: vm.pwCheckInput)
            .disposed(by: bag)
        
        
        submitButton.rx.tap
            .bind(to: vm.submitButtonTapped)
            .disposed(by: bag)
        
        vm.inputUnvalid
            .bind(to: self.rx.setAlert)
            .disposed(by: bag)
        
        vm.requestRegistResult
            .filter{$0.0 == false}
            .map{ result -> Alert in
                return Alert(title:"실패" , message:result.1 ?? "잠시후 다시 시도해 주세요." )
            }
            .emit(to: self.rx.setAlert)
            .disposed(by: bag)
    }
}
private extension RegistViewController{
    func attribute()
    {
        view.backgroundColor = .systemBackground
        self.title = "회원가입"
        [emailLabel, pwInput, pwCheckInput,
         nickNameInput, submitButton].forEach{
            view.addSubview($0)
        }
        submitButton.setBackgroundColor(.systemGray, for: .highlighted)
    }
    func layout(){
        emailLabel.snp.makeConstraints{
            $0.height.equalTo(50)
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.leading.trailing.equalToSuperview().inset(10)
        }
        
        nickNameInput.snp.makeConstraints{
            $0.top.equalTo(emailLabel.snp.bottom).offset(5)
            $0.height.equalTo(emailLabel.snp.height)
            $0.leading.trailing.equalToSuperview().inset(10)
        }
        
        pwInput.snp.makeConstraints{
            $0.height.equalTo(50)
            $0.top.equalTo(nickNameInput.snp.bottom).offset(5)
            $0.trailing.leading.equalToSuperview().inset(10)
        }
        
        pwCheckInput.snp.makeConstraints{
            $0.height.equalTo(pwInput.snp.height)
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.top.equalTo(pwInput.snp.bottom).offset(5)
        }
        submitButton.snp.makeConstraints
        {
            $0.height.equalTo(pwInput.snp.height)
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.top.equalTo(pwCheckInput.snp.bottom).offset(10)
        }
    }
    
}

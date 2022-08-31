//
//  LoginViewController.swift
//  Blamarket
//
//  Created by yangjs on 2022/08/17.
//

import UIKit
import RxSwift
import SnapKit
import RxCocoa
import RxGesture

class LoginViewController  : UIViewController{
    let bag = DisposeBag()
    
    private lazy var loading : UIActivityIndicatorView = {
        let loading = UIActivityIndicatorView()
        loading.style = .large
        return loading
    }()
    

    private lazy var idInput : UITextField = {
        let textField = UITextField()
        textField.placeholder = "      아이디를 입력해주세요"
        textField.borderStyle = .bezel
        return textField
    }()



    private lazy var pwInput : UITextField = {
        let textField = UITextField()
        textField.placeholder = "      비밀번호"
        textField.borderStyle = .bezel
        textField.isSecureTextEntry = true
        return textField
    }()



    private lazy var loginButton : UIButton = {
        let button = UIButton()
        button.setTitle("로그인", for: .normal)
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.systemBlue.cgColor
        return button
    }()

    private lazy var registerButton : UIButton = {
        let button = UIButton()
        button.setTitle("회원가입", for: .normal)
        button.tintColor = .systemBlue
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.systemBlue.cgColor

        return button
    }()

    private lazy var pwResetBtn : UILabel = {
        let label = UILabel()
        label.text = "비밀번호 초기화"
        label.font = .systemFont(ofSize: 10)
        label.textColor = .systemGray
        return label
    }()



    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        attribute()
        layout()
        //bind(MainViewModel())
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bind(vm:LoginViewModel){
        idInput.rx.text.orEmpty
            .bind(to: vm.id)
            .disposed(by: bag)

        pwInput.rx.text.orEmpty
            .bind(to: vm.pw)
            .disposed(by: bag)

        loginButton.rx.tap
            .throttle(.microseconds(500), scheduler: MainScheduler.instance)
            .bind(to: vm.loginButtonTapped)
            .disposed(by: bag)
        


        vm.presentAlert
            .emit(to: self.rx.setAlert)
            .disposed(by: bag)

        pwResetBtn.rx.tapGesture().when(.recognized)
            .throttle(.microseconds(500), scheduler: MainScheduler.instance)
            .bind{[weak self] _ in
                guard let self = self else {return }
                print("password find tapped")
                let passwordRestVC = PasswordResetViewController()
                passwordRestVC.bind(vm: PasswordResetViewModel())
                self.navigationController?.pushViewController(passwordRestVC, animated: true)
            }.disposed(by: bag)

        registerButton.rx.tap
            .throttle(.microseconds(500), scheduler: MainScheduler.instance)
            .bind{ [weak self] _ in
                guard let self = self else {return }
                print("register find tapped")
                let emailAuthVC = EmailAuthViewController()
                emailAuthVC.bind(vm: EmailAuthViewModel())
                self.navigationController?.pushViewController(emailAuthVC, animated: true)
            }.disposed(by: bag)
        
        
        vm.goMainPage.emit(onNext:{ [weak self] in
            print("LOGIN SUCCESS")
            guard let self = self else { return }
            let mainVC = MainViewController()
            mainVC.bind(vm: MainViewModel())
            self.loading.rx.isAnimating.onNext(false)
            self.navigationController?.pushViewController(mainVC, animated: true)
        }).disposed(by: bag)
    }

}

private extension LoginViewController{
    func attribute(){
        self.navigationItem.title  = "로그인"

    }

    func layout(){
        [idInput, pwInput, loginButton, registerButton,pwResetBtn,loading].forEach {
            view.addSubview($0)
        }
        loading.snp.makeConstraints{
            $0.centerX.centerY.equalToSuperview()
        }
        
        idInput.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.leading.trailing.equalToSuperview().inset(10)
        }

        pwInput.snp.makeConstraints{
            $0.height.equalTo(50)
            $0.top.equalTo(idInput.snp.bottom).offset(5)
            $0.trailing.leading.equalToSuperview().inset(10)
        }

        loginButton.snp.makeConstraints{
            $0.height.equalTo(50)
            $0.top.equalTo(pwInput.snp.bottom).offset(20)
            $0.trailing.leading.equalToSuperview().inset(10)
        }
        pwResetBtn.snp.makeConstraints{
            $0.top.equalTo(loginButton.snp.bottom).offset(10)
            $0.centerX.equalTo(loginButton.snp.centerX)
        }

        registerButton.snp.makeConstraints{
            $0.height.equalTo(50)
            $0.top.equalTo(pwResetBtn.snp.bottom).offset(10)
            $0.trailing.leading.equalToSuperview().inset(10)
        }


    }
}


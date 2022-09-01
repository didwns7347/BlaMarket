//
//  EmailAuthViewController.swift
//  Blamarket
//
//  Created by yangjs on 2022/08/31.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class EmailAuthViewController: UIViewController{
    let bag = DisposeBag()
    private var timer : Timer?
    #if DEBUG
    var limitTime = 10
    #else
    var limitTime = 180
    #endif
    private lazy var emailTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "가입 이메일을 입력해주세요"
        textField.borderStyle = .bezel
        return textField
    }()
    
    private lazy var emailAuthCodeTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "인증코드"
        textField.borderStyle = .bezel
        textField.isEnabled = false
        return textField
    }()
    
    private lazy var sendAuthCodeButton : UIButton = {
        let button = UIButton()
        button.setTitle("전송", for: .normal)
        button.backgroundColor = ColorConst.MAIN_COLOR
        return button
    }()
    
    private lazy var checkAuthCode : UIButton = {
        let button = UIButton()
        button.setTitle("확인", for: .normal)
        button.backgroundColor = ColorConst.MAIN_COLOR
        return button
    }()
    
    func bind(vm:EmailAuthViewModel){
        
        sendAuthCodeButton.rx.tap
            .bind(onNext: { _ in
                vm.sendCode.accept(())
            })
            .disposed(by: bag)
        
        
        /**
         인증코드 서버 전송 성공
         */
        vm.requestMailCode.filter{$0.0}
            .emit(onNext:{[weak self] result in
                print(result)
                guard let self = self else{return}
                self.emailRequsetSuccess()
            }).disposed(by: bag)
        
        /**
         인증코드 서버전송 실패
         */
        vm.requestMailCode
            .filter{$0.0 == false}
            .map{ result -> Alert in
                print(result)
                return Alert(title:"실패" , message:result.1 ?? "잠시후 다시 시도해 주세요." )
            }.emit(to: self.rx.setAlert)
            .disposed(by: bag)

        self.emailTextField.rx.text.orEmpty
            .bind(to: vm.inputEmail)
            .disposed(by: bag)
        
        vm.inputInvalid
            .bind(to: self.rx.setAlert)
            .disposed(by: bag)
     
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension EmailAuthViewController{
    func attribute(){
        self.title = "이메일 인증"
        [emailTextField, emailAuthCodeTextField, sendAuthCodeButton,checkAuthCode]
            .forEach {view.addSubview($0)}
        self.view.backgroundColor = .systemBackground
        sendAuthCodeButton.setBackgroundColor(.systemGray, for: .highlighted)
        checkAuthCode.setBackgroundColor(.systemGray, for: .highlighted)
        checkAuthCode.isHidden = true
        
    }
    
    func showCheckAuthButton(){
        
    }
    
    func layout(){
        emailTextField.snp.makeConstraints{ make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.leading.trailing.equalToSuperview().inset(10)
        }
        emailAuthCodeTextField.snp.makeConstraints{
            $0.height.equalTo(50)
            $0.top.equalTo(emailTextField.snp.bottom).offset(5)
            $0.trailing.leading.equalToSuperview().inset(10)
        }
        sendAuthCodeButton.snp.makeConstraints{
            $0.top.equalTo(emailAuthCodeTextField.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.height.equalTo(emailTextField.snp.height)
        }
        checkAuthCode.snp.makeConstraints{
            $0.edges.equalTo(sendAuthCodeButton.snp.edges)
        }
    }
    
    func emailRequsetSuccess(){
        self.sendAuthCodeButton.isHidden = true
        self.checkAuthCode.isHidden = false
        self.emailAuthCodeTextField.isEnabled = true
        self.timerStart()
    }
    
    func timerStart(){
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block:{t in
            self.limitTime -= 1
            print("Running Timer")
            let minutes = self.limitTime / 60
            let seconds = self.limitTime % 60
            if self.limitTime > 0{
                self.emailAuthCodeTextField.placeholder = String(format: "%02d:%02d", minutes, seconds)
            }else{
                self.emailAuthCodeTextField.placeholder = "만료"
                self.limitTime = 180
                if self.timer != nil{
                    print("끝")
                    self.timer?.invalidate()
                    self.timer = nil
                }
            }
        } )
    }
}

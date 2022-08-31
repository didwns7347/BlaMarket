//
//  RegistViewController.swift
//  Blamarket
//
//  Created by yangjs on 2022/08/19.
//

import RxSwift
import UIKit
import RxCocoa

class RegistViewController : UIViewController{
    private lazy var idTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "       아이디를 입력해주세요"
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.systemGray.cgColor
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private lazy var pwInput : UITextField = {
        let textField = UITextField()
        textField.placeholder = "       비밀번호를 입력해주세요"
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.systemGray.cgColor
        textField.isSecureTextEntry = true
        return textField
    }()
    
    lazy var pwCheckInput : UITextField = {
        let textField = UITextField()
        textField.placeholder = "      비밀번호 확인"
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.systemGray.cgColor
        textField.isSecureTextEntry = true
        return textField
    }()
    
    lazy var nickNameInput : UITextField = {
        let textField = UITextField()
        textField.placeholder = "      닉네임"
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.systemGray.cgColor
        return textField
    }()
    
    lazy var mailCodeInput : UITextField = {
        let textField = UITextField()
        textField.placeholder = "인증코드전송"
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.systemGray.cgColor
        return textField
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
        
    }
}
private extension RegistViewController{
    func attribute()
    {
        view.backgroundColor = .systemBackground
        
    }
    func layout(){
        
    }
    
}

//
//  PasswordResetViewController.swift
//  Blamarket
//
//  Created by yangjs on 2022/08/19.
//

import UIKit
class PasswordResetViewController : UIViewController{
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        attribute()
        layout()
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(vm:PasswordResetViewModel){
        
    }
    
}
private extension PasswordResetViewController{
    func attribute(){
        self.view.backgroundColor = .systemBackground
    }
    func layout(){
        
    }
}

//
//  MainViewController.swift
//  Blamarket
//
//  Created by yangjs on 2022/08/24.
//

import UIKit
import RxSwift
import RxCocoa

class MainViewController : UIViewController{

    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    func bind(vm: MainViewModel){
        
    }
    
    
}
private extension MainViewController{
    func attribute(){
        view.backgroundColor = .systemBackground
        self.title = "로그인 성공"
    }
    
    func layout(){
        
    }
}

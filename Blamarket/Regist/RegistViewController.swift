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

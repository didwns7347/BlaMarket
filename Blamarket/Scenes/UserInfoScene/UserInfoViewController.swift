//
//  UserInfoViewController.swift
//  Blamarket
//
//  Created by yangjs on 2022/10/19.
//

import UIKit

class UserInfoViewConroller : UIViewController{
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
private extension UserInfoViewConroller{
    func attribute(){
        self.view.backgroundColor = .systemBackground
        self.title = "내 정보"
    }
    
    func layout(){
        
    }
}

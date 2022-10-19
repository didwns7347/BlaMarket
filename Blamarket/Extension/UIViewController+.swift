//
//  UIViewController+.swift
//  Blamarket
//
//  Created by yangjs on 2022/08/31.
//

import RxCocoa
import RxSwift
import UIKit
import Alamofire
typealias Alert = (title:String, message:String?)
extension UIViewController{
//    func showToolBar(){
//        self.navigationController?.isToolbarHidden = false
//        var shareButton: UIBarButtonItem!
//        var sortButton: UIBarButtonItem!
//        var trashButton: UIBarButtonItem!
//        shareButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
//        sortButton = UIBarButtonItem(title: "최신순", style: .plain, target: self, action: nil)
//        trashButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: nil)
//        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
//        var items = [UIBarButtonItem]()
//
//        [shareButton,flexibleSpace,sortButton,flexibleSpace,trashButton].forEach {
//            items.append($0)
//        }
//        self.toolbarItems = items
//    }
//    
//    @objc func addTapped(){
//        self.navigationController?.viewControllers.forEach({ vc in
//            print(vc is MainViewController)
//            self.navigationController.p
//        })
//        self.navigationController?.pushViewController(DetailViewController(), animated: true)
//        print("add")
//    }
}

extension Reactive where Base : UIViewController{
    var setAlert : Binder<Alert> {
        return Binder(base){ base , data in
            let alertController = UIAlertController(title: data.title, message: data.message, preferredStyle: .alert)
            let action = UIAlertAction(title: "확인", style: .cancel)
            alertController.addAction(action)
            base.present(alertController, animated:true , completion: nil)
        }
    }
    
    var completeAlert :Binder<Alert>{
        return Binder(base){base ,data in
            let alertController = UIAlertController(title: data.title, message: data.message, preferredStyle: .alert)
            let action = UIAlertAction(title: "확인", style: .cancel){ action in
                base.navigationController?.popViewController(animated: true)
            }
            alertController.addAction(action)
            base.present(alertController, animated:true , completion: nil)
            
        }
    }
    
    var startLoading : Binder<Bool>{
        return Binder(base){base, isStart in
            
        }
    }
}

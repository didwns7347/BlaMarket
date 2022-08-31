//
//  UIViewController+.swift
//  Blamarket
//
//  Created by yangjs on 2022/08/31.
//

import RxCocoa
import RxSwift
import UIKit
typealias Alert = (title:String, message:String?)

extension Reactive where Base : UIViewController{
    var setAlert : Binder<Alert> {
        return Binder(base){ base , data in
            let alertController = UIAlertController(title: data.title, message: data.message, preferredStyle: .alert)
            let action = UIAlertAction(title: "확인", style: .cancel)
            alertController.addAction(action)
            base.present(alertController, animated:true , completion: nil)
        }
    }
}

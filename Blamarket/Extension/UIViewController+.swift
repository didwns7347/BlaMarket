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
//typealias AlertAction = (title:String , style : UIAlertAction.Style)
struct AlertAction {
    var title: String
    var style: UIAlertAction.Style

    static func action(title: String, style: UIAlertAction.Style = .default) -> AlertAction {
        return AlertAction(title: title, style: style)
    }
}


extension Reactive where Base : UIViewController{
    var viewWillAppear: ControlEvent<Bool> {
       let source = self.methodInvoked(#selector(Base.viewWillAppear)).map { $0.first as? Bool ?? false }
       return ControlEvent(events: source)
     }
    
    var setAlert : Binder<Alert> {
        return Binder(base){ base , data in
            let alertController = UIAlertController(title: data.title, message: data.message, preferredStyle: .alert)
            let action = UIAlertAction(title: "확인", style: .cancel)
            alertController.addAction(action)
            base.present(alertController, animated:true , completion: nil)
        }
    }
    
    var actionSheetAlert : Binder<[UIAlertAction]> {
        return Binder(base){ base , actions in
            let alertConroller = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            for action in actions{
                alertConroller.addAction(action)
            }
            base.present(alertConroller,animated: true, completion: nil)
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

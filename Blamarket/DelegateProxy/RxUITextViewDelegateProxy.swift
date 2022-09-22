//
//  RxUITextViewDelegateProxy.swift
//  Blamarket
//
//  Created by yangjs on 2022/09/22.
//

import RxSwift
import RxCocoa
import UIKit
//class RxUITextViewDelegateProxy: DelegateProxy<UITextView, UITextViewDelegate>, DelegateProxyType, UITextViewDelegate{
//    static func registerKnownImplementations() {
//        self.register{ textView -> RxUITextViewDelegateProxy in
//            RxUITextViewDelegateProxy(parentObject: textView, delegateProxy: self)
//            
//        }
//    }
//    
//    static func currentDelegate(for object: UITextView) -> UITextViewDelegate? {
//        return object.delegate
//    }
//    
//    static func setCurrentDelegate(_ delegate: UITextViewDelegate?, to object: UITextView) {
//        object.delegate = delegate
//    }
//    
//    
//}

//
//  TokenManager.swift
//  Blamarket
//
//  Created by yangjs on 2022/11/10.
//

import Foundation
import RxCocoa
import RxSwift
class TokenManager{
    
    static let shared = TokenManager()
    let bag = DisposeBag()
    let key = UserConst.AccessToken
    func isAutoLoginAvailable()->Bool{
        guard let lastLoginDate = UserDefaults.standard.object(forKey: UserConst.LAST_LOGIN_DATE) as? Date
        else{
            return false
        }
        
        var dateComponentDay = DateComponents()
        dateComponentDay.day = UserConst.Login_Alive_Time
        let expireDate = Calendar.current.date(byAdding: dateComponentDay, to: lastLoginDate) ?? Date()
        //만료된경우 토큰값 갱신.
        if expireDate <= Date(){
            KeyChainManager.removedataInKeyChain(key: UserConst.Authorize_key)
            return false
        }
        return true
    }
    
    func updateToken(){
        let endPoint = UserEndPoint.updateToken()
        let provider = NetworkProvider()
        provider.tokenRequest(with: endPoint).subscribe(onNext: { result in
            guard let token = result else {
                print("Token = NIL")
                return
            }
            print("Token = \(token)")
            KeyChainManager.saveWithKey(key: UserConst.AccessToken, value: token)
        }).disposed(by: bag)
        
    }
    
    func createToken(token:String){
        KeyChainManager.saveWithKey(key: UserConst.AccessToken, value: token)
    }
    
    func readToken()->String?{
        return KeyChainManager.getDataWithKey(key: UserConst.AccessToken)
    }
    
}

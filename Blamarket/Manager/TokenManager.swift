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
    //마지막으로 받은 토큰 날짜 갱신
    func renewDate(){
        UserDefaults.standard.set(Date(), forKey: UserConst.LAST_TOKEN_DATE)
    }
    
    func isExpired()->Bool{
        guard let lastLoginDate = UserDefaults.standard.object(forKey: UserConst.LAST_TOKEN_DATE) as? Date
        else{
            return true
        }
        
        var dateComponentDay = DateComponents()
        dateComponentDay.day = UserConst.Login_Alive_Time
        let expireDate = Calendar.current.date(byAdding: dateComponentDay, to: lastLoginDate) ?? Date()
        //만료된경우 토큰값 갱신.
        if expireDate <= Date(){
            //KeyChainManager.removedataInKeyChain(key: UserConst.Authorize_key)
            return true
        }
        return false
    }
    
    func updateToken(){
        guard let token = readToken() else{
            print("NO TOKEN IN KEY CHAIN")
            return
        }
        let endPoint = UserEndPoint.updateToken(token: token)
        let provider = NetworkProvider()
        provider.tokenRequest(with: endPoint).subscribe(onNext: { result in
            guard let token = result else {
                print("Token = NIL")
                return
            }
            print("Token = \(token)")
            self.createToken(token: token)
        }).disposed(by: bag)
        
    }
    
    func createToken(token:String){
        KeyChainManager.saveWithKey(key: UserConst.AccessToken, value: token)
        self.renewDate()
    }
    
    func readToken()->String?{
        return KeyChainManager.getDataWithKey(key: UserConst.AccessToken)
    }
    
}
// MARK: JWT 토큰 디코딩
extension TokenManager{
    func decode(jwtToken jwt: String) -> [String: Any] {
        let segments = jwt.components(separatedBy: ".")
        return decodeJWTPart(segments[1]) ?? [:]
    }
    
    func base64UrlDecode(_ value: String) -> Data? {
        var base64 = value
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        
        let length = Double(base64.lengthOfBytes(using: String.Encoding.utf8))
        let requiredLength = 4 * ceil(length / 4.0)
        let paddingLength = requiredLength - length
        if paddingLength > 0 {
            let padding = "".padding(toLength: Int(paddingLength), withPad: "=", startingAt: 0)
            base64 = base64 + padding
        }
        return Data(base64Encoded: base64, options: .ignoreUnknownCharacters)
    }
    
    func decodeJWTPart(_ value: String) -> [String: Any]? {
        guard let bodyData = base64UrlDecode(value),
              let json = try? JSONSerialization.jsonObject(with: bodyData, options: []), let payload = json as? [String: Any] else {
            return nil
        }
        
        return payload
    }
}

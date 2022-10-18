//
//  KeychinManager.swift
//  Blamarket
//
//  Created by yangjs on 2022/10/12.
//

import Foundation

class KeyChainManager{
    static func saveWithKey(key: String, value: String){
        let pwData = value.data(using: .utf8) ?? Data()
        let query : [CFString:Any] = [kSecClass: kSecClassGenericPassword,
                                        kSecAttrAccount: key,
                                        kSecValueData:pwData]
        let status = SecItemAdd(query as CFDictionary, nil)
        if status == errSecSuccess{
            log.debug("saved in keychain!!")
        }else if status == errSecDuplicateItem{
            return
        }else{
            log.debug("saved in keychain failed !!")
        }
    }
    
    static func getDataWithKey(key:String) -> String?{
        let query : [CFString: Any] = [kSecClass: kSecClassGenericPassword,
                                 kSecAttrAccount: key,
                            kSecReturnAttributes:true,
                                  kSecReturnData: true]
        
        var item : CFTypeRef?
        if SecItemCopyMatching(query as CFDictionary, &item) != errSecSuccess{
            log.debug("get data In KeyChain Failed!!")
            return nil
        }
        guard let existingIem = item as? [String:Any],
              let data = existingIem[kSecValueData as String] as? Data,
              let password = String(data:data, encoding: .utf8)
        else {
            return nil
        }
        
        return password
    }
    
    
    static func removedataInKeyChain(key:String){
        let deleteQuery : [CFString:Any] = [kSecClass: kSecClassGenericPassword,
                                      kSecAttrAccount: key]
        
        let status = SecItemDelete(deleteQuery as CFDictionary)
        if status == errSecSuccess{
            log.debug("remove key-data complete")
        }else{
            log.debug("remove key-data Failed")
        }
    }
    
    static func clear(){
        let deleteQuery : [CFString:Any] = [kSecClass: kSecClassGenericPassword]
        
        let status = SecItemDelete(deleteQuery as CFDictionary)
        if status == errSecSuccess{
            log.debug("clear key-data complete")
        }else{
            log.debug("clear key-data Failed")
        }
    }
    
}

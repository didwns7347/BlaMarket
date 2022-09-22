//
//  RegisterItemModel.swift
//  Blamarket
//
//  Created by yangjs on 2022/09/22.
//

import Foundation
struct RegisterItemModel{
    func setAlert(errorMessage:[String])->(title:String, message:String?){
        let title = errorMessage.isEmpty ? "성공":"실패"
        let message = errorMessage.isEmpty ? nil:errorMessage.joined(separator: "\n")
        return (title:title, message:message)
    }
}
    

//
//  Dummy.swift
//  BlamarketTests
//
//  Created by yangjs on 2022/11/22.
//

import Foundation
@testable import Blamarket

var postList : [PostEntity] = PostDummy().load("PostDummy.json")

class PostDummy{
    func load<T:Decodable>(_ fileName:String) -> T{
        let data : Data
        let bundle = Bundle(for: type(of: self))
         
        guard let file = bundle.url(forResource: fileName, withExtension: nil)
        else{
            fatalError("\(fileName)을 main bundle에서 불러올 수없음.")
        }
        
        do{
            data = try Data(contentsOf: file)
        }catch
        {
            fatalError("\(fileName) can't load main bundle : \(error.localizedDescription)")
        }
        
        do{
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        }catch{
            fatalError("\(fileName) can not parsing \(T.self)")
        }
    }
}

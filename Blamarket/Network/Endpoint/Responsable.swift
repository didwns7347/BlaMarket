//
//  Responsable.swift
//  Blamarket
//
//  Created by yangjs on 2022/08/24.
//

import Foundation
import UIKit.UIImage

protocol RequestResponsable : Requestable,Responsable {}

protocol Responsable{
    associatedtype Response
}

class Endpoint<R> : RequestResponsable{
    typealias Response = R
    
    var baseURL: String
    var path: String
    var method: HttpMethod
    var queryParameters: Encodable?
    var bodyParameters: Encodable?
    var headers: [String: String]?
    var sampleData: Data?
    var uploadImages : [UIImage]?
    
    init(baseURL: String,
         path: String = "",
         method: HttpMethod = .get,
         queryParameters: Encodable? = nil,
         bodyParameters: Encodable? = nil,
         headers: [String: String]? = nil,
         sampleData: Data? = nil,
         uploadImages:[UIImage]? = nil) {
        self.baseURL = baseURL
        self.path = path
        self.method = method
        self.queryParameters = queryParameters
        self.bodyParameters = bodyParameters
        self.headers = headers
        self.sampleData = sampleData
        self.uploadImages = uploadImages
    }
    
}



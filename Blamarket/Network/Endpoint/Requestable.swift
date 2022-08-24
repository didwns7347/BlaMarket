//
//  Requestable.swift
//  Blamarket
//
//  Created by yangjs on 2022/08/24.
//

import Foundation

protocol Requestable{
    var baseURL : String {get}
    var path : String {get}
    var method : HttpMethod {get}
    var queryParameters : Encodable? {get}
    var bodyParameters : Encodable? {get}
    var headers : [String:String]? {get}
    var sampleData: Data? {get}
}
extension Requestable{
    func getUrlRequest() throws -> URLRequest{
        let url = try url()
        var urlRequest = URLRequest(url: url)
        
        if let bodyParameters = try bodyParameters?.toDictionary(){
            if !bodyParameters.isEmpty{
                urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: bodyParameters)
            }
        }
        
        urlRequest.httpMethod = method.rawValue
        
        headers?.forEach{urlRequest.setValue($1, forHTTPHeaderField: $0)}
        
        return urlRequest
    }
    
    func url() throws -> URL{
        let fullPath = "\(baseURL)\(path)"
        guard var urlComponets = URLComponents(string: fullPath) else {
            throw NetworkError.components
        }
        
        var urlQueryItems = [URLQueryItem]()
        if let queryParameters = try queryParameters?.toDictionary(){
            queryParameters.forEach{key,value in
                urlQueryItems.append(URLQueryItem(name: key, value: "\(value)"))
            }
        }
        urlComponets.queryItems = !urlQueryItems.isEmpty ? urlQueryItems : nil
        
        guard let url = urlComponets.url else { throw NetworkError.components}
        return url
    }
}

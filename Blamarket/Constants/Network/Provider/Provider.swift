//
//  Provider.swift
//  Blamarket
//
//  Created by yangjs on 2022/08/24.
//

import Foundation
import RxSwift

protocol Provider{
    
    //특정 responsable이 존재하는 request
    //func request<R:Decodable, E:RequestResponsable>(with endPoint :E, completion:@escaping (Result<R,Error>) -> Void) where E.Response == R
    
    func request(_ url:URL)->Single<Result<Data,Error>>
    
    func request<R: Decodable, E: RequestResponsable>(with endPoint: E) -> Single<Result<R,Error>> where E.Response == R
    
}

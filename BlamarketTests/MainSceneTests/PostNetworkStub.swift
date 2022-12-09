//
//  PostNetworkStub.swift
//  BlamarketTests
//
//  Created by yangjs on 2022/11/22.
//

import Foundation
import RxSwift
import Stubber

@testable import Blamarket
class PostNetworkStub : NetworkProvider {
    override func request<R, E>(with endPoint: E) -> Single<Result<R, Error>> where R : Decodable, R == E.Response, E : RequestResponsable {
        return Stubber.invoke(request, args: endPoint)
    }
    
}

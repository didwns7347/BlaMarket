//
//  Sessionable.swift
//  Blamarket
//
//  Created by yangjs on 2022/08/24.
//

import Foundation
import RxSwift

protocol URLSessionable {
    func dataTask(with request: URLRequest,
                  completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
    func dataTask(with url: URL,
                  completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}
extension URLSession : URLSessionable{}

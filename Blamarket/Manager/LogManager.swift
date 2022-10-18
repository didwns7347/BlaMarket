//
//  LogManager.swift
//  Blamarket
//
//  Created by yangjs on 2022/10/12.
//


import Foundation
struct log{
    static func debug( _ message: String = "", file: String = #file, line: Int = #line) {
#if DEBUG
        print("\(Date()) MSG = \(message) \n:: \(file):\(line)")
#endif
    }
}

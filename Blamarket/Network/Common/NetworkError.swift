//
//  NetworkError.swift
//  Blamarket
//
//  Created by yangjs on 2022/08/24.
//

import Foundation


enum NetworkError: LocalizedError{
    case sessionError
    case unknownError
    case invalidHttpStatusCode(Int)
    case components
    case urlRequest(Error)
    case parsing(Error)
    case emptyData
    case decodeError
    case urlError
    var errorDescription: String?{
        switch self{
        case .sessionError:
            return "URLSession 타입이 아닙니다."
        case .unknownError :
             return "알수 없는 에러입니다."
        case .invalidHttpStatusCode(let statuscode):
            return "statuscode = \(statuscode)"
        case .components:
            return "components 생성 에러 발생"
        case .urlError:
            return "URL 생성 에러"
        case .urlRequest(let error):
            return "url request 관련 에러 발생 \n\(error.localizedDescription)"
        case .parsing(let error):
            return "데이터 파싱 에러 \n\(error.localizedDescription)"
        case .emptyData:
            return "빈 데이터"
        case .decodeError:
            return "디코딩 에러"
        }
    }
}

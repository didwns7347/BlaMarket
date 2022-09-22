//
//  File.swift
//  Blamarket
//
//  Created by yangjs on 2022/08/25.
//

import Foundation
import RxSwift
class NetworkProvider : Provider{
    
    let session : URLSession
    init(session: URLSession = URLSession.shared){
        self.session = session

    }
    
    func request(_ url: URL) -> Single<Result<Data, Error>> {
        var request = URLRequest(url: url)
        request.timeoutInterval = TimeInterval(10)
        return session.rx.response(request:request)
            .map(self.checkError).asSingle()
    }
    
    //endPoint 와 Response가 같은경우 -> 파싱할데이터를 endPoint파라메터를 통해 주입받음.
    func request<R:Decodable, E: RequestResponsable>(with endPoint: E) -> Single<Result<R, Error>>  where E.Response == R {
    
        guard let requset = try? endPoint.getUrlRequest() else {
            return .just(.failure(NetworkError.urlError))
        }
        
        return session.rx.response(request: requset)
            .map(checkError)
            .map{ result -> Result<R,Error> in
                switch result{
                case .success(let data):
                    return self.decode(data: data)
                case.failure(let error):
                    return .failure(error)
                }
            }
            .asSingle()
    }
    private func checkError(with response: HTTPURLResponse, _ data: Data)->Result<Data,Error>{
        #if DEBUG
        print("responseData = \n\(data.prettyPrintedJSONString ?? "FAILED")")
        #endif
        guard (200...299).contains(response.statusCode) else{
            return .failure(NetworkError.invalidHttpStatusCode(response.statusCode))
        }
        
        guard !data.isEmpty else{
            return .failure(NetworkError.emptyData)
        }
        return .success(data)
        
    }
    
    
    private func decode<R:Decodable>(data:Data) -> Result<R,Error>{
        do{
            let decoded = try JSONDecoder().decode(R.self, from: data)
            return .success(decoded)
        }catch{
            print(error.localizedDescription)
            print(String(describing: error))
            return .failure(NetworkError.emptyData)
        }
    }
    
    
}


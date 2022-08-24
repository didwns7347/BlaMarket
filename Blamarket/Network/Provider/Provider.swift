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
class UserNetwork : Provider{
    
    let session : URLSession
    init(session: URLSession = URLSession.shared){
        self.session = session
    }
    
    func request(_ url: URL) -> Single<Result<Data, Error>> {
        let request = URLRequest(url: url)
        return session.rx.response(request:request)
            .map(self.checkError).asSingle()
    }
    
  
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
            return .failure(NetworkError.emptyData)
        }
    }
    
    
}

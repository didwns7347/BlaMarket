//
//  File.swift
//  Blamarket
//
//  Created by yangjs on 2022/08/25.
//

import Foundation
import RxSwift
import RxCocoa
import RxAlamofire
import Alamofire
class NetworkProvider : Provider{
    let bag = DisposeBag()
    let session : URLSessionable
    init(session: URLSessionable = URLSession.shared){
        self.session = session
        
    }
    
    func request(_ url: URL) -> Single<Result<Data, Error>> {
        guard let session = session as? URLSession else{
            return .just(.failure(NetworkError.sessionError))
        }
        var request = URLRequest(url: url)
        request.timeoutInterval = TimeInterval(300)
        return session.rx.response(request:request)
            .map(self.checkError).asSingle()
    }
    func tokenRequest<E:RequestResponsable>(with endPoint: E)->Observable<String?>{
        guard let session = session as? URLSession else{
            return .just(nil)
        }
        guard let requset = try? endPoint.getUrlRequest() else {
            return .just(nil)
        }
        
        return session.rx.response(request: requset)
            .map{response -> String? in
                let headers = response.response.value(forHTTPHeaderField: UserConst.jwtToken)
                return headers
            }
        
    }
    
    
    
    //endPoint 와 Response가 같은경우 -> 파싱할데이터를 endPoint파라메터를 통해 주입받음.
    func request<R:Decodable, E: RequestResponsable>(with endPoint: E) -> Single<Result<R, Error>>  where E.Response == R {
        guard let session = session as? URLSession else{
            return .just(.failure(NetworkError.sessionError))
        }
        guard let requset = try? endPoint.getUrlRequest() else {
            return .just(.failure(NetworkError.urlError))
        }
        
        let result = session.rx.response(request: requset)
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
        //result.catchErrorJustReturn(Result.)
        
        return result
    }
    
    func multipartRequest<R:Decodable, E: RequestResponsable>(with endPoint: E) -> Single<Result<R,Error>>  where E.Response == R {
        return Single<Result<R,Error>>.create { observer in
            guard let requset = try? endPoint.getMultipartRequest() else {
                observer(.failure(NetworkError.urlError))
                return Disposables.create{}
            }
            AF.upload(multipartFormData: { multipartFormData in
                let params = endPoint.bodyParameters as! [String:Any]
                for (key, value) in params {
                    multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
                }
                //            print(imageData?.pngData()?.count/1024)
                var cnt = 0
                for img in endPoint.uploadImages!{
                    if let image = img.pngData() {
                        print(image.count/1024)
                        multipartFormData.append(image, withName: "imageList", fileName: "\(cnt).png", mimeType: "image/png")
                        cnt+=1
                    }
                    
                }
            }, to:endPoint.urlString() ,usingThreshold: UInt64.init() ,method: .post, headers: HTTPHeaders(endPoint.headers ?? [:]))
            .response{afResponse in
                switch afResponse.result{
                case .failure(let error):
                    observer(.failure(error))
                case .success(let data):
                    observer(.success(self.decode(data: data ?? Data())))
                  
                }
            }
            return Disposables.create{}
        }
    }
    private func checkError(with response: HTTPURLResponse, _ data: Data)->Result<Data,Error>{
#if DEBUG
        print("responseData = \n\(data.prettyPrintedJSONString ?? "FAILED")")
        print(response.headers.value(for: "JWT-AUTHENTICATION") ?? "NO TOKEN IN HEADER")
#endif
        if TokenManager.shared.readToken()==nil{
            if let toekn = response.headers.value(for: UserConst.jwtToken){
                TokenManager.shared.createToken(token: toekn)
            }
        }
        
        guard (200...299).contains(response.statusCode) else{
            return .failure(NetworkError.invalidHttpStatusCode(response.statusCode))
        }
        
        guard !data.isEmpty else{
            return .failure(NetworkError.emptyData)
        }
        return .success(data)
        
    }
    
    
    private func decode<R:Decodable>(data:Data) -> Result<R,Error>{
        #if DEBUG
        print("JSON STRING => data")
        print(String(data: data, encoding: .utf8))
        #endif
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

